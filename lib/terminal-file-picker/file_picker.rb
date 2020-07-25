require 'tty-cursor'
require 'tty-reader'
require_relative 'file_browser_view'
require_relative 'helper'

# Responsible for keeping the state of the interactive file picker.
# Also responds to user input to modify the state and redraw
# file picker to reflect new state.
class FilePicker
  def initialize(dir_path, options = {})
    @root_path = dir_path
    @dir = FileBrowserView.new(options)
    @reader = TTY::Reader.new(interrupt: :exit)
    @reader.subscribe(self)
    @user_have_picked = false
    @page = 0
    @cursor = TTY::Cursor

    @date_format = options.fetch(:date_format, '%d/%m/%Y')
    @time_format = options.fetch(:time_format, '%H:%M')
    change_directory(dir_path)
  end

  def pick_file
    @user_have_picked = false
    redraw(false)

    @cursor.invisible do
      @reader.read_keypress until @user_have_picked
    end

    print(@cursor.clear_screen_down)
    file_path_of_selected
  end

  def keydown(_event)
    @selected += 1 unless selected_at_bottom?
    if selected_below_page?
      @page += 1
      print(@cursor.clear_screen_down)
    end
    redraw(true)
  end

  def keyup(_event)
    @selected -= 1 unless selected_at_top?
    if selected_above_page?
      @page -= 1
      print(@cursor.clear_screen_down)
    end
    redraw(true)
  end

  def keypress(event)
    case event.value
    when "\r"
      if File.directory?(file_path_of_selected)
        change_directory(file_path_of_selected)
        print(@cursor.clear_screen_down)
        # Cache keeps a rendering of current directory.
        # Going to a new directory, so needs to refresh
        # the cache.
        redraw(false)
      else
        @user_have_picked = true
      end
    end
  end

  private

  def redraw(use_cache)
    rendered = @dir.render(@current_path, @files, @selected, @page, use_cache)
    Helper.print_in_place(rendered)
  end

  def selected_at_top?
    @selected.zero?
  end

  def selected_at_bottom?
    @selected == @files.length - 1
  end

  def selected_above_page?
    @selected < (@page * @dir.files_per_page)
  end

  def selected_below_page?
    @selected > (@page * @dir.files_per_page) + @dir.files_per_page - 1
  end

  def files_in_dir(dir_path)
    Dir.entries(dir_path).map do |f|
      size_bytes = File.size(file_path(f))

      mtime = File.mtime(file_path(f))
      date_mod = mtime.strftime(@date_format)
      time_mod = mtime.strftime(@time_format)

      name = add_indicator(f)

      [name, size_bytes, date_mod, time_mod]
    end
  end

  def change_directory(file_path)
    @page = 0
    @selected = 0
    @current_path = file_path
    @files = order_files(files_in_dir(@current_path))
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

  def add_indicator(file_name)
    file_path = file_path(file_name)
    return file_name unless File.directory?(file_path)

    "#{file_name}/"
  end

  def file_path(file_name)
    return @current_path if file_name == '.'

    File.join(@current_path, file_name)
  end

  def file_path_of_selected
    file_path(@files[@selected].first)
  end
end
