Gem::Specification.new do |spec|
  spec.name = "terminal-file-picker"
  spec.version = "0.1.0"
  spec.authors = ["Ilkut Kutlar"]
  spec.email = ["ilkutkutlar@gmail.com"]
  spec.summary = %q{Interactive terminal file picker}
  spec.description = %q{The gem brings up an interactive file browser that can be drawn on a terminal or terminal emulator that allows a user to browse their files and pick one. The picked file path is then returned to caller of the gem.}
  spec.files = [
    "README.md",
    "lib/directory_view.rb",
    "lib/file_picker.rb",
    "lib/helper.rb"
  ]
  spec.require_paths = ["lib"]
end
