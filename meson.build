project(
	'com.github.albe-rosado.hujing',
	['c', 'vala'],
	version: '0.1.0',
	meson_version: '>= 0.40.0',
)

add_global_arguments('-DGETTEXT_PACKAGE="com.github.albe-rosado.hujing"', language:'c')


i18n = import('i18n')


subdir('data')
subdir('src')
subdir('po')

meson.add_install_script('build-aux/meson/postinstall.py')