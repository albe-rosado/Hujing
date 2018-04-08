# Hujing

[![Build Status](https://travis-ci.org/albe-rosado/Hujing.svg?branch=master)](https://travis-ci.org/albe-rosado/Hujing)
A very simple and easy to use GNOME application  for installing **flatpak** bundles without having to use the terminal. Made with love for those who aren't necessarily "good with computers" and just want something simple and reliable to install their apps.


## Installation

### Dependencies
These dependencies must be present before building
 - `valac`
 - `gtk+-3.0`
 - `granite`
 - `packagekit-glib2`
 
 Install it on Ubuntu based distributions doing:

 `sudo apt install valac libgranite-dev libpackagekit-glib2-dev  libgtk-3-dev`

### Building
``` bash
meson builddir
(cd builddir && ninja)
# and run it
./builddir/src/com.github.albe-rosado.hujing
```
### Contributing

We'd love to have your helping hand! 
- If you like this app and have an idea of how to improve it or want to add an additional feature, create an issue explaining your idea. 
- If something doesn’t work, please [file an issue](https://github.com/albe-rosado/Hujing/issues/new).
- Be nice.

### ToDo

- [ ] Provide `deb` and `rpm` bundles
- [ ] Add "Open with" integration
- [ ]  Manage  installed apps (list, delete)