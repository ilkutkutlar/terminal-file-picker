Gem::Specification.new do |spec|
  spec.name = 'terminal-file-picker'
  spec.version = '0.0.1'
  spec.authors = ['Ilkut Kutlar']
  spec.email = ['ilkutkutlar@gmail.com']
  spec.summary = 'Interactive terminal file picker'
  spec.description = 'This gem shows an interactive terminal file picker to' \
                     'user, allowing them to browse their files with arrow'  \
                     'keys. The picked file path is then returned to the'    \
                     'calling program.'
  spec.homepage = 'https://github.com/ilkutkutlar/terminal-file-picker'
  spec.files = [
    'README.md',
    'lib/file_picker.rb',
    'lib/file_browser_view.rb',
    'lib/helper.rb'
  ]
  spec.require_paths = ['lib']
  spec.add_development_dependency "rspec"
end
