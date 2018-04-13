/*
* Copyright (c) 2018
*
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

using Gtk;

public class App : Granite.Application {

	private MainWindow? main_window;
	private const string[] SUPPORTED_MIMETYPES = {"application/vnd.flatpak", "application/vnd.flatpak.repo", "application/vnd.flatpak.ref"};
	private const string APP_NAME = "Hujing";
	private const string APP_ID = "com.github.albe-rosado.hujing";
	private const string EXEC_NAME = "hujing";
	private const string DESKTOP_NAME = "com.github.albe-rosado.hujing.desktop";


	construct {
		flags |= ApplicationFlags.HANDLES_OPEN;
		application_id = APP_ID;
		program_name = APP_NAME;
		exec_name = EXEC_NAME;
		app_launcher = DESKTOP_NAME;
		register_app_handler ();
	}

	public static int main (string[] args) {
		App app = new App ();
		return app.run (args);
	}

	public override void activate () {
		if (main_window == null) {
			main_window = new MainWindow ();
			add_window(main_window);
			main_window.show_all();
		}
		else {
			main_window.present ();
		}
	}

	private static void register_app_handler () {
		DesktopAppInfo app_info = new DesktopAppInfo (DESKTOP_NAME);
		if (app_info == null) {
			debug ("Couldn't AppInfo for %s", APP_NAME);
			return;
		}
		try {
			app_info.set_as_default_for_extension("flatpakref");
			app_info.set_as_default_for_type ("application/vnd.flatpak.ref");
		}
		catch (Error error) {
			warning (error.message);
		}
	}


	public override void open (File[] files, string hint) {
		File bundle = files[0];
		activate ();
		if (main_window != null) {
			main_window.open_file(bundle.get_uri ());
		}
	}

}
