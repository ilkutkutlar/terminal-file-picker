require 'tty-screen'
require_relative 'helper'
require_relative 'table'

# Renders a directory view with pagination support. Allows
# highlighting an item in the directory to indicate its selected.
# Instance stores directory view rendering options.
class FileBrowserView
  attr_reader :files_per_page

  def initialize(options = {})
    default_header = ['Name', 'Size (B)', 'Date modified', 'Time modified']
    @header = options.fetch(:header, default_header)
    @dir_label = options.fetch(:dir_label, 'Directory')
    @page_label = options.fetch(:page_label, 'Page')
    @left_pad = options.fetch(:left_pad, 2)
    @right_pad = options.fetch(:right_pad, 2)
    @files_per_page = options.fetch(:files_per_page, 10)
    @show_info_line = options.fetch(:show_info_line, true)
    @info_line_position = options.fetch(:info_line_position, :top)
    @cache = ''
  end

  def render(dir_path, files, selected_index, page, use_cache = false)
    files_table = files_table_string(files, use_cache)
    file_browser = render_file_browser(files_table, selected_index, page)

    return file_browser unless @show_info_line

    info_line = info_bar(files.length, page, dir_path)
    return "#{info_line}\n\n#{file_browser}" if @info_line_position == :top

    "#{file_browser}\n\n#{info_line}"
  end

  private

  def render_file_browser(rendered_files_table, selected_index, page)
    rendered_rows = rendered_files_table.split("\n")

    header = rendered_rows[0..1].join("\n")

    body_rows = rendered_rows[2..]
    body_rows = highlight_row(body_rows, selected_index)
    body_rows = paginate_table_body(body_rows, page)
    body = body_rows.join("\n")

    "#{header}\n#{body}"
  end

  def files_table_string(files, use_cache)
    @table = Table.new(@header, files, @left_pad, @right_pad)

    @cache = @table.render if !use_cache || (use_cache && @cache.empty?)
    return @cache unless table_width_overflowed?

    @cache.split("\n").map do |line|
      line[0..(screen_width - 1)]
    end.join("\n")
  end

  def highlight_row(rows, row_no)
    rows[row_no] = Helper.highlight(rows[row_no])

    rows
  end

  def info_bar(total_files, page, dir_path)
    page_count = (total_files.to_f / @files_per_page).ceil
    page_info = "#{@page_label}: #{page + 1}/#{page_count}"
    dir_info = "#{@dir_label}: #{dir_path}"
    info_bar = "#{page_info} | #{dir_info}"
    return info_bar unless info_bar.length > screen_width

    info_bar[0..screen_width - 1]
  end

  def paginate_table_body(body_rows, page_no)
    page_start = page_no * @files_per_page
    page_end = page_start + (@files_per_page - 1)

    body_rows[page_start..page_end]
  end

  def table_width_overflowed?
    @table.total_row_size >= screen_width
  end

  def screen_width
    TTY::Screen.width
  end
end
