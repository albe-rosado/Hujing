hujing_sources = [
  'main.vala',
  'window.vala',
]

hujing_deps = [
  dependency('gio-2.0', version: '>= 2.50'),
  dependency('gtk+-3.0', version: '>= 3.22'),
]

gnome = import('gnome')

hujing_sources += gnome.compile_resources('hujing-resources',
  'hujing.gresource.xml',
  c_name: 'hujing'
)

executable('hujing', hujing_sources,
  vala_args: '--target-glib=2.50',  dependencies: hujing_deps,
  install: true,
)
