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

public class MainWindow : ApplicationWindow {

	private HeaderBar header_bar;
	private Granite.Widgets.Welcome welcome_widget;

	construct {
		// temp window attrs
		default_height = 580;
		default_width = 460;

		header_bar = new HeaderBar();
		header_bar.set_title("Hujing");
		header_bar.show_close_button = true;
		set_titlebar(header_bar);

		welcome_widget = new Granite.Widgets.Welcome("Install some flatpaks", "Drad and drop or open flatpakref files to begin");
		add(welcome_widget);


	}
}
