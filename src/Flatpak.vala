/* * Copyright (c) 2018 *
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Alberto Rosado <alberosado7@gmail.com>
*/



public class Flatpak {

	public static void install_bundle (string bundle_uri) {

		MainLoop loop = new MainLoop ();

		try {
			string file_path = Filename.from_uri (bundle_uri, null);
			string[] spawn_args = {"flatpak", "install", "-y", file_path};
			Pid child_pid;
			int std_error;
			string error_text = null;

			Process.spawn_async_with_pipes ("/",
				spawn_args,
				null,
				SpawnFlags.SEARCH_PATH | SpawnFlags.DO_NOT_REAP_CHILD,
				null,
				out child_pid,
				null,
				null,
				out std_error);

			// handle error message from terminal
			IOChannel error = new IOChannel.unix_new (std_error);
			error.add_watch (IOCondition.IN | IOCondition.HUP, (channel, condition) => {
				if (condition == IOCondition.HUP) {
					warning ("The fd has been closed.\n");
					return false;
				}

				try {
					string line;
					channel.read_line (out line, null, null);
					error_text = string.join(error_text, line);
					return true;
				}
				catch {
					return false;
				}

			});

			ChildWatch.add (child_pid, (pid, status) => {
				// Triggered when the child indicated by child_pid exits
				debug ("Installation process done with  pid: %d and status: %d \n", pid, status);

				if (status > 0) {

					Granite.MessageDialog error_message_dialog = new Granite.MessageDialog.with_image_from_icon_name (
					"",
					error_text,
					"dialog-error");

					error_message_dialog.run ();
					error_message_dialog.destroy ();
				}
				else {
					Granite.MessageDialog success_message_dialog = new Granite.MessageDialog.with_image_from_icon_name (
					"",
					"The application was successfully installed.",
					"dialog-ok");

					success_message_dialog.run ();
					success_message_dialog.destroy ();
				}
				Process.close_pid (pid);
				loop.quit ();
			});

			loop.run ();
		}
		catch (SpawnError error) {
			warning ("Error: %s \n", error.message);
		}
		catch (ConvertError error) {
			warning ("Error: %s \n", error.message);
		}
	}


	private static string detect_distro () {
		MainLoop loop = new MainLoop ();
		string output_text = "unknown";
		try {
			string[] spawn_args = {"lsb_release", "-is"};
			Pid child_pid;
			int std_out;
			Process.spawn_async_with_pipes ("/",
				spawn_args,
				null,
				SpawnFlags.SEARCH_PATH | SpawnFlags.DO_NOT_REAP_CHILD,
				null,
				out child_pid,
				null,
				out std_out,
				null);


			// handle error message from terminal
			IOChannel output = new IOChannel.unix_new (std_out);
			output.add_watch (IOCondition.IN | IOCondition.HUP, (channel, condition) => {
				if (condition == IOCondition.HUP) {
					message ("The fd has been closed.\n");
					return false;
				}

				try {
					string line;
					channel.read_line (out line, null, null);
					output_text = string.join(output_text, line);
					return true;
				}
				catch {
					return false;
				}

			});

			ChildWatch.add (child_pid, (pid, status) => {
				// Triggered when the child indicated by child_pid exits
				debug ("Distro detection process done with  pid: %d and status: %d \n", pid, status);
				Process.close_pid (pid);
				loop.quit ();
			});

			loop.run ();
		}
		catch (SpawnError error) {
			warning ("Error: %s \n", error.message);
		}

		return output_text.strip ();
	}

	public static bool flatpak_installed () {
		MainLoop loop = new MainLoop ();
		bool exists = false;
		try {
			string[] spawn_args = {"which", "flatpak"};
			Pid child_pid;
			Process.spawn_async ("/",
				spawn_args,
				null,
				SpawnFlags.SEARCH_PATH | SpawnFlags.DO_NOT_REAP_CHILD,
				null,
				out child_pid);


			ChildWatch.add (child_pid, (pid, status) => {
				// Triggered when the child indicated by child_pid exits
				debug ("flatpak lookup process done with  pid: %d and status: %d \n", pid, status);
				if (status == 0) {
					exists = true;
				}
				Process.close_pid (pid);
				loop.quit ();
			});

			loop.run ();
		}
		catch (SpawnError error) {
			warning ("Error: %s \n", error.message);
		}

		return exists;
	}

	public static void install_flatpak () {
		MainLoop loop = new MainLoop ();
		string distro_name = detect_distro ();
		string[] install_command = {"gksudo", "--", "bash", "-c"};

		switch (distro_name) {
			case "elementary":
			case "Ubuntu":
				install_command += "add-apt-repository ppa:alexlarsson/flatpak && apt update && apt install flatpak";
				break;
			case "Debian":
				install_command += "apt install flatpak;";
				break;
			case "openSUSE":
				install_command += "zypper install flatpak;";
				break;
			case "Arch":
				install_command += "pacman -S flatpak;";
				break;
			case "Solus":
				install_command += "eopkg install flatpak;";
				break;
			case "Fedora":
				// included by default;
				install_command = {"exit", "0"};
				break;
			case "unknown":
			default:
				install_command = {"exit", "1"};
				break;
		}
		try {
			Pid child_pid;

			Process.spawn_async ("/",
				install_command,
				null,
				SpawnFlags.SEARCH_PATH | SpawnFlags.DO_NOT_REAP_CHILD,
				null,
				out child_pid);

			ChildWatch.add (child_pid, (pid, status) => {
				// Triggered when the child indicated by child_pid exits
				debug ("flatpak installation process done with  pid: %d and status: %d \n", pid, status);
				if (status > 0) {
					Granite.MessageDialog error_message_dialog = new Granite.MessageDialog.with_image_from_icon_name (
					"",
					"Something went wrong while installing flatpak.",
					"dialog-error");
					error_message_dialog.run ();
					error_message_dialog.destroy ();
				}
				Process.close_pid (pid);
				loop.quit ();
			});

			loop.run ();
		}
		catch (SpawnError error) {
			warning ("Error: %s \n", error.message);
		}

	}

}