require 'tty-table'
require 'tty-screen'
require_relative 'helper'

class DirectoryView
  attr_reader :files_per_page

  def initialize(options = {})
    @header = options.fetch(:header,
                            ['Name', 'Size', 'Date modified', 'Time modified'])
    @dir_label = options.fetch(:dir_label, 'Directory')
    @page_label = options.fetch(:page_label, 'Page')
    @left_pad = options.fetch(:left_pad, 2)
    @right_pad = options.fetch(:right_pad, 2)
    @files_per_page = options.fetch(:files_per_page, 10)
    @show_info_line = options.fetch(:show_info_line, true)
    @info_line_position = options.fetch(:info_line_position, :top)
    @screen_width = TTY::Screen.width
  end

  def render(dir_path, files, selected_index, page)
    table = TTY::Table.new(@header, files)
    
    table_rendered = table.render(:basic) do |r|
      r.width = @screen_width
      r.resize = table_width_overflowed?(table.width)
      table_padding(r)
      table_border(r)
      table_selected_row(r, selected_index)
    end

    header = get_lines(table_rendered, 0..1)
    body = get_lines(table_rendered, 2..)
    page_body = paginate_table_body(body, page)
    table_str = "#{header}\n#{page_body}"

    if @show_info_line
      info_line = info_bar(files.length, page, dir_path)

      if @info_line_position == :top
        "#{info_line}\n\n#{table_str}"
      else
        "#{table_str}\n\n#{info_line}"
      end
    else
      table_str
    end
  end

  private

  def table_width_overflowed?(table_content_width)
    table_padding = @header.length * (@left_pad + @right_pad) + 1
    full_table_length = table_content_width + table_padding
    
    full_table_length >= @screen_width
  end

  def info_bar(total_files, page, dir_path)
    page_count = (total_files.to_f / @files_per_page).ceil
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
