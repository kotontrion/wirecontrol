wirecontrol_sources = [
  'main.vala',
  'application.vala',
  'window.vala',
  'endpoint.vala',
]

wirecontrol_deps = [
  config_dep,
  dependency('gtk4'),
  dependency('libadwaita-1', version: '>= 1.4'),
  dependency('astal-wireplumber-0.1'),
]

blueprints = custom_target('blueprint-compiler',
  input: files(
    'window.blp',
    'endpoint.blp',
  ),
  output: '.',
  command: [find_program('blueprint-compiler'), 'batch-compile', '@OUTPUT@', '@CURRENT_SOURCE_DIR@', '@INPUT@'],
)


wirecontrol_sources += gnome.compile_resources('wirecontrol-resources',
  'wirecontrol.gresource.xml',
  dependencies: blueprints,
  c_name: 'wirecontrol'
)

executable('wirecontrol', wirecontrol_sources,
  dependencies: wirecontrol_deps,
  include_directories: config_inc,
  install: true,
)
