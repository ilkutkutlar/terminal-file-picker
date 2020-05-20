require 'tty-cursor'
require 'tty-reader'
require_relative 'directory_view'
require_relative 'helper.rb'
require 'benchmark'

class FilePicker
  def initialize(dir_path, options = {})
    @root_path = dir_path
    @dir = DirectoryView.new(options)
    @reader = TTY::Reader.new
    @reader.subscribe(self)
    @user_have_picked = false
    @page = 0

    change_directory(dir_path)
  end

  def pick_file
    @user_have_picked = false
    print(TTY::Cursor.hide)
    redraw

    until @user_have_picked
      begin
        @reader.read_keypress
      rescue Exception
        print(TTY::Cursor.show)
        exit 0
      end
    end

    print(TTY::Cursor.clear_screen_down)
    print(TTY::Cursor.show)
    full_path_of_selected
  end

  def keydown(_event)
    @selected += 1 unless selected_at_bottom?
    if selected_below_page?
      @page += 1
      print(TTY::Cursor.clear_screen_down)
    end
    redraw
  end

  def keyup(_event)
    @selected -= 1 unless selected_at_top?
    if selected_above_page?
      @page -= 1
      print(TTY::Cursor.clear_screen_down)
    end
    redraw
  end

  def keypress(event)
    case event.value
    when "\r"
      if File.directory?(full_path_of_selected)
        change_directory(full_path_of_selected)
        print(TTY::Cursor.clear_screen_down)
        redraw
      else
        @user_have_picked = true
      end
    end
  end

  private

  def redraw
    Helper.print_in_place(
      @dir.render(@current_path, @files, @selected, @page)
    )
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
      size_bytes = File.size(full_path(f))

      mtime = File.mtime(full_path(f))
      date_mod = mtime.strftime('%d/%m/%Y')
      time_mod = mtime.strftime('%H:%M')

      name = file_display_name(f)

      [name, size_bytes, date_mod, time_mod]
    end
  end

  def change_directory(full_path)
    @current_path = full_path
    @files = order_files(files_in_dir(@current_path))
    @selected = 0
  end

  def order_files(files)
    # Put "." and ".." at the start
    groups = files.group_by do |f|
      if f.first == '.' || f.first == '..'
        :dots
      else
        :files
      end
    end

    # Sort so that "." comes before ".."
    (groups[:dots] || []).sort + (groups[:files] || [])
  end

  def full_path(file_name)
    return @current_path if file_name == "."
    return "#{@current_path}#{file_name}" if @current_path[-1] == '/'

    "#{@current_path}/#{file_name}"
  end

  def full_path_of_selected
    full_path(@files[@selected].first)
  end

  def file_display_name(file_name)
    if File.directory?(full_path(file_name))
      return "#{file_name}/" unless ['.', '..'].include?(file_name)
    end

    file_name
  end
end
