require_relative 'file_picker'
require 'filesize'
# puts(Filesize.from("#{size_bytes} B").to_s("KB"))

def files_in_dir(dir_path)
  Dir.entries(dir_path).map do |f|
    size_bytes = File.size(f)
    mtime = File.mtime(f)
    date_mod = mtime.strftime("%d/%m/%Y")
    time_mod = mtime.strftime("%H:%M")
    [f, size_bytes, date_mod, time_mod]
  end
end

# test_files = [
#   ["test", "40K", "16/05/2020", "19:30"],
#   ["Lorem Ipsum", "1M", "19/03/2020", "18:30"],
#   ["Some file", "500K", "16/05/2020", "00:30"]
# ]

files = files_in_dir(".")
picker = FilePicker.new(files, ".")
puts(picker.pick_file)
