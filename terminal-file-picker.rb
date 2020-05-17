require_relative 'lib/file_picker'

picker = FilePicker.new('.', header: %w[hi hello cool hey])
puts(picker.pick_file)
