Gem::Specification.new do |spec|
  spec.name = "terminal-file-picker"
  spec.version = "0.1.0"
  spec.authors = ["Ilkut Kutlar"]
  spec.email = ["ilkutkutlar@gmail.com"]
  spec.summary = %q{Interactive terminal file picker}
  spec.description = %q{This gem shows an interactive terminal file picker to user, allowing them to browse their files with arrow keys and file. The picked file path is then returned to the calling program.}
  spec.files = [
    "README.md",
    "lib/directory_view.rb",
    "lib/file_picker.rb",
    "lib/helper.rb"
  ]
  spec.require_paths = ["lib"]
end
