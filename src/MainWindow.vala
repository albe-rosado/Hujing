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

using Gtk;

public class MainWindow : ApplicationWindow {

	private const Gtk.TargetEntry[] DRAG_TARGETS = {{ "text/uri-list", 0, 0 }};

	private HeaderBar header_bar;
	private Granite.Widgets.Welcome welcome_widget;

	construct {
		set_size_request( 700, 600);

		header_bar = new HeaderBar();
		header_bar.set_title("Hujing");
		header_bar.show_close_button = true;
		set_titlebar(header_bar);


		welcome_widget = new Granite.Widgets.Welcome("Install some flatpaks", "Drad and drop or open flatpakref files to begin");
		welcome_widget.append ("document-open", "Open", "Browse to apen a file");
		add(welcome_widget);

		welcome_widget.activated.connect (show_open_file_diag);


		// drag and drop
		drag_dest_set (this, DestDefaults.MOTION | DestDefaults.DROP, DRAG_TARGETS, Gdk.DragAction.COPY);
		drag_data_received.connect (on_drag_data_recieved);
	}

	private void on_drag_data_recieved (Gdk.DragContext drag_context,
		int x, int y, Gtk.SelectionData data, uint info, uint time) {

		drag_finish (drag_context, true, false, time);
		Flatpak.install_app (data.get_uris () [0]);
	}


	private void show_open_file_diag () {
		FileChooserDialog file_chooser = new FileChooserDialog ("Select flatpakref files to install",
										this,
										FileChooserAction.OPEN,
										"Cancel",
										ResponseType.CLOSE,
										"Open",
										ResponseType.ACCEPT);

		FileFilter flatpak_filter = new FileFilter ();
		flatpak_filter.set_filter_name ("Flatpak bundles");
		flatpak_filter.add_pattern ("*.flatpakref");

		FileFilter all_files_filter = new FileFilter ();
		all_files_filter.set_filter_name ("All files");
		all_files_filter.add_pattern ("*");

		file_chooser.add_filter (flatpak_filter);
		file_chooser.add_filter (all_files_filter);

		file_chooser.select_multiple = false;

		file_chooser.response.connect ((response) => {
			if (response == ResponseType.ACCEPT) {
				string file_uri = file_chooser.get_uri ();
				file_chooser.destroy ();
				Flatpak.install_app (file_uri);
			}
			else {
				file_chooser.destroy ();
			}
		});

		file_chooser.run ();
	}

}
