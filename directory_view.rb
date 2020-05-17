require 'tty-table'
require_relative 'helper'

class DirectoryView
  def initialize(files = [], dir_path = '')
    @files = files
    @dir_path = dir_path
  end

  def set_directory(files, dir_path)
    @files = files
    @dir_path = dir_path
  end

  def render(selected_index)
    header = ['Name', 'Size', 'Date modified', 'Time modified']
    table = TTY::Table.new(header, @files)

    rendered = table.render do |r|
      table_padding(r)
      table_border(r)
      table_selected_row(r, selected_index)
    end

    "Directory: #{@dir_path}\n\n#{rendered}"
  end

  private

  def table_padding(renderer)
    renderer.padding = [0, 2, 0, 2]
  end

  def table_border(renderer)
    renderer.border do
      center ''
      mid '-'
    end
  end

  def table_selected_row(renderer, selected_index)
    renderer.filter = proc do |val, row_index, _col_index|
      # + 1 to account for the header
      if row_index == (selected_index + 1)
        select(val)
      else
        val
      end
    end
  end
end
