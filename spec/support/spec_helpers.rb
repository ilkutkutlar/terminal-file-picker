module SpecHelpers
  def mock_file_sizes(files, starting_path)
    files.each do |file|
      file_path = File.join(starting_path, file[0])
      size = file[1]

      allow(File).to receive(:size).with(file_path).and_return(size)
    end
  end

  def mock_file_modified_times(files, starting_path)
    files.each do |file|
      file_path = File.join(starting_path, file[0])
      mtime = Time.parse("#{file[2]} #{file[3]}")

      allow(File).to receive(:mtime).with(file_path).and_return(mtime)
    end
  end

  def mock_dir_entries(dir_path, files)
    file_names_only = files.map(&:first)
    allow(Dir).to receive(:entries).with(dir_path).and_return(file_names_only)
  end
end
