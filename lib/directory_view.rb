require 'tty-table'
require_relative 'helper'

class DirectoryView
  attr_reader :files_per_page

  def initialize(options = {})
    @header = options.fetch(:header,
                            ['Name', 'Size', 'Date modified', 'Time modified'])
    @dir_label = options.fetch(:dir_label, 'Directory')
    @left_pad = options.fetch(:left_pad, 2)
    @right_pad = options.fetch(:right_pad, 2)
    @files_per_page = options.fetch(:files_per_page, 10)
    @page_label = options.fetch(:page_label, 'Page')
  end

  def render(dir_path, files, selected_index, page)
    table = TTY::Table.new(@header, files)

    rendered = table.render do |r|
      table_padding(r)
      table_border(r)
      table_selected_row(r, selected_index)
    end

    info_line = info_bar(files.length, page, dir_path)
    header = get_lines(rendered, 0..1)
    body = get_lines(rendered, 2..)
    page_body = paginate_table_body(body, page)

    "#{info_line}\n\n#{header}\n#{page_body}"
  end

  private

  def info_bar(total_files, page, dir_path)
    page_count = (total_files.to_f/@files_per_page).ceil
    "#{@page_label}: #{page + 1}/#{page_count} | #{@dir_label}: #{dir_path}"
  end

  def paginate_table_body(body, page_no)
    page_start = page_no * @files_per_page
    page_end = page_start + (@files_per_page - 1)
    
    get_lines(body, page_start..page_end)
  end

  def get_lines(text, line_range)
    text.split("\n")[line_range].join("\n")
  end

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
