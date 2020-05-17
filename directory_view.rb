require 'tty-table'

class DirectoryView
  def initialize(files, dir_path)
    @files = files
    @dir_path = dir_path
  end

  def render(selected_index)
    header = ["Name", "Size", "Date modified", "Time modified"]
    table = TTY::Table.new(header, @files)

    rendered = table.render do |r|
      r.padding = [0, 2, 0, 2]

      r.border do 
        center ''
        mid '-'
      end

      r.filter = Proc.new do |val, row_index, col_index|
        # + 1 to account for the header
        if row_index == (selected_index + 1)
          select(val)
        else
          val
        end
      end
    end

    "Directory: #{@dir_path}\n\n#{rendered}"
  end
end
