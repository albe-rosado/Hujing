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

public class Hujing.MainWindow : ApplicationWindow {

	private const Gtk.TargetEntry[] DRAG_TARGETS = {{ "text/uri-list", 0, 0 }};

	private HeaderBar header_bar;
	private Granite.Widgets.Welcome welcome_widget;
	private Button open_button;

	construct {
		set_size_request( 700, 600);

		header_bar = new HeaderBar();
		header_bar.set_title("Hujing");
		header_bar.show_close_button = true;
		set_titlebar(header_bar);

		welcome_widget = new Granite.Widgets.Welcome("Install some flatpaks", "Drad and drop or open flatpakref files to begin");
		add(welcome_widget);

		open_button = new Button.from_icon_name("document-open", IconSize.LARGE_TOOLBAR);
		open_button.tooltip_text = "Open";
		add(open_button);

		// drag and drop
		drag_dest_set (this, DestDefaults.MOTION | DestDefaults.DROP, DRAG_TARGETS, Gdk.DragAction.COPY);
		drag_data_received.connect (on_drag_data_recieved);
	}

	private void on_drag_data_recieved (Gdk.DragContext drag_context,
		int x, int y, Gtk.SelectionData data, uint info, uint time) {

		FlatpakHandler.install_app (data.get_uris ());
		drag_finish (drag_context, true, false, time);
	}




}
