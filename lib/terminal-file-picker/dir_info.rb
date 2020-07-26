# Functions related to retrieving and formatting
# information related to directories and their contents.
module DirInfo
  class << self
    def files_in_dir(dir_path, options = {})
      date_format = options.fetch(:date_format, '%d/%m/%Y')
      time_format = options.fetch(:time_format, '%H:%M')

      Dir.entries(dir_path).map do |f|
        file_path = File.join(dir_path, f)

        name = add_indicator(f, dir_path)

        size_bytes = File.size(file_path)

        mtime = File.mtime(file_path)
        date_mod = mtime.strftime(date_format)
        time_mod = mtime.strftime(time_format)

        [name, size_bytes, date_mod, time_mod]
      end
    end

    private

    def add_indicator(file_name, dir_path)
      file_path = File.join(dir_path, file_name)
      return "#{file_name}/" if File.directory?(file_path)

      file_name
    end
  end
end
