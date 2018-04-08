sources = [
	'App.vala',
	'MainWindow.vala',
	'Flatpak.vala',
	'SpinnerView.vala',
]

deps = [
	dependency('gio-2.0', version: '>= 2.50'),
	dependency('glib-2.0', version: '>= 2.50'),
	dependency('gtk+-3.0', version: '>= 3.22'),
	dependency('granite', version: '>=0.4.0.1'),
]

gnome = import('gnome')

executable(
	'Hujing',
	sources,
	vala_args: '--target-glib=2.50',
	dependencies: deps,
	install: true,
)
