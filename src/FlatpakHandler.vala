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


public class Hujing.FlatpakHandler {



	private static bool process_line (IOChannel channel, IOCondition condition, string stream_name) {

		try {
			string line;
			channel.read_line (out line, null, null);

			int name_end_pos = line.index_of_char ('/');
			string app_name = line.slice (0, name_end_pos);

			stdout.printf ("%s \n" ,app_name);
		} catch (IOChannelError e) {
			stdout.printf ("%s: IOChannelError: %s\n", stream_name, e.message);
			return false;
		} catch (ConvertError e) {
			stdout.printf ("%s: ConvertError: %s\n", stream_name, e.message);
			return false;
		}
		return true;
	}

	public static void list_apps () {
		MainLoop loop = new MainLoop ();
		try {
			string[] spawn_args = {"flatpak", "list", "--app"};
			string[] spawn_env = Environ.get ();
			Pid child_pid;

			int standard_input;
			int standard_output;
			int standard_error;

			Process.spawn_async_with_pipes ("/",
				spawn_args,
				spawn_env,
				SpawnFlags.SEARCH_PATH | SpawnFlags.DO_NOT_REAP_CHILD,
				null,
				out child_pid,
				out standard_input,
				out standard_output,
				out standard_error);

			// stdout:
			IOChannel output = new IOChannel.unix_new (standard_output);
			output.add_watch (IOCondition.IN | IOCondition.HUP, (channel, condition) => {
				return process_line (channel, condition, "stdout");
			});

			// stderr:
			IOChannel error = new IOChannel.unix_new (standard_error);
			error.add_watch (IOCondition.IN | IOCondition.HUP, (channel, condition) => {
				return process_line (channel, condition, "stderr");
			});

			ChildWatch.add (child_pid, (pid, status) => {
				// Triggered when the child indicated by child_pid exits
				Process.close_pid (pid);
				loop.quit ();
			});

			loop.run ();
		} catch (SpawnError e) {
			stdout.printf ("Error: %s\n", e.message);
		}
	}

	public static void install_app (string[] bundle_paths) {
		for (int i = 0; i < bundle_paths.length; i++) {
			stdout.printf ("%s \n", bundle_paths[i]);
		}
	}

}