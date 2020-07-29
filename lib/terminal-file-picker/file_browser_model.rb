# Functions related to retrieving and formatting
# information related to directories and their contents.
class FileBrowserModel
  attr_accessor :selected, :page, :current_path, :files

  def initialize(starting_path, options = {})
    @options = options
    @current_path = starting_path
    @page = 0
    @selected = 0
    @files = order_files(files_in_dir)
  end

  def files_in_dir
    date_format = @options.fetch(:date_format, '%d/%m/%Y')
    time_format = @options.fetch(:time_format, '%H:%M')

    Dir.entries(@current_path).map do |f|
      file_path = File.join(@current_path, f)

      name = add_indicator(f)

      size_bytes = File.size(file_path)

      mtime = File.mtime(file_path)
      date_mod = mtime.strftime(date_format)
      time_mod = mtime.strftime(time_format)

      [name, size_bytes, date_mod, time_mod]
    end
  end

  # Order files such that '.' and '..' come before
  # all the other files.
  def order_files(files)
    # Put "." and ".." at the start
    groups = files.group_by do |f|
      if f.first == './' || f.first == '../'
        :dots
      else
        :files
      end
    end

    # Sort so that "." comes before ".."
    (groups[:dots] || []).sort.reverse + (groups[:files] || [])
  end

  def path_rel_to_start(file_name)
    File.join(@current_path, file_name)
  end

  private

  def add_indicator(file_name)
    return "#{file_name}/" if File.directory?(path_rel_to_start(file_name))

    file_name
  end
end
