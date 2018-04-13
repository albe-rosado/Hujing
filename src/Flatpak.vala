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
					stdout.printf ("The fd has been closed.\n");
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
				stdout.printf ("Installation process done with  pid: %d and status: %d \n", pid, status);

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
			stdout.printf ("Error: %s \n", error.message);
		}
		catch (ConvertError error) {
			stdout.printf ("Error: %s \n", error.message);
		}
	}

}