require_relative 'file_picker'
require 'filesize'
# puts(Filesize.from("#{size_bytes} B").to_s("KB"))

picker = FilePicker.new(".")
puts(picker.pick_file)
