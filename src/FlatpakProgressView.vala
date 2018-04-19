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


public class FlatpakProgressView: Grid {

	public FlatpakProgressView () {
		Grid spinner_grid = new Grid ();

		Spinner spinner = new Spinner ();
		spinner.start ();

		Label message = new Label ("<i>Looks like you dont have Flatpak in your system, please wait while we install it for you...</i>");
		message.set_use_markup (true);

		spinner_grid.halign = Align.CENTER;
		spinner_grid.orientation = Orientation.VERTICAL;
		spinner_grid.add (spinner);
		spinner_grid.add (message);
		add (spinner_grid);
	}
}