Gem::Specification.new do |spec|
  spec.name = 'terminal-file-picker'
  spec.version = '0.0.5'
  spec.authors = ['Ilkut Kutlar']
  spec.email = ['ilkutkutlar@gmail.com']
  spec.summary = 'Interactive terminal file picker'
  spec.description = 'This gem shows an interactive terminal file picker to user, allowing them to browse their files with arrow keys. The picked file path is then returned to the calling program.'
  spec.homepage = 'https://github.com/ilkutkutlar/terminal-file-picker'
  spec.license = 'MIT'
  spec.files = Dir['lib/**/*']
  spec.extra_rdoc_files = ['README.md', 'LICENSE']
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_dependency 'pastel', '~> 0.7.4'
  spec.add_dependency 'tty-cursor', '~> 0.7.1'
  spec.add_dependency 'tty-reader', '~> 0.7.0'
  spec.add_dependency 'tty-screen', '~>0.7.1'

  spec.add_development_dependency 'rspec', '~> 3.9'
  spec.add_development_dependency 'rubocop', '~> 0.82.0'
end
