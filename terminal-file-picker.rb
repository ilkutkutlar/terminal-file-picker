require_relative 'lib/file_picker'

picker = FilePicker.new('.', date_format: '%d-%m-%Y')
puts(picker.pick_file)
