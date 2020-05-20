require_relative 'lib/file_picker'

picker = FilePicker.new('.')
puts(picker.pick_file)
