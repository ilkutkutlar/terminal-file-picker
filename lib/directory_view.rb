require 'tty-table'
require_relative 'helper'

class DirectoryView
  def initialize(options = {})
    @header = options.fetch(:header,
                            ['Name', 'Size', 'Date modified', 'Time modified'])
    @dir_label = options.fetch(:dir_label, 'Directory')
    @left_pad = options.fetch(:left_pad, 2)
    @right_pad = options.fetch(:right_pad, 2)
  end

  def render(files, dir_path, selected_index)
    table = TTY::Table.new(@header, files)

    rendered = table.render do |r|
      table_padding(r)
      table_border(r)
      table_selected_row(r, selected_index)
    end

    "#{@dir_label}: #{dir_path}\n\n#{rendered}"
  end

  private

  def table_padding(renderer)
    renderer.padding = [0, @right_pad, 0, @left_pad]
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
        Helper.highlight(val)
      else
        val
      end
    end
  end
end
