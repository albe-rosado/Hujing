project(
  'com.github.albe-rosado.Hujing',
  ['c', 'vala'],
  version: '0.1.0',
  meson_version: '>= 0.40.0',
)

sources = [
  'src/App.vala',
  'src/MainWindow.vala',
]

deps = [
  dependency('gio-2.0', version: '>= 2.50'),
  dependency('gtk+-3.0', version: '>= 3.22'),
]

gnome = import('gnome')


executable('app', sources, vala_args: '--target-glib=2.50',  dependencies: deps)
