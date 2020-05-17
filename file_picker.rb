require 'tty-cursor'
require 'pry'
require 'tty-reader'
require_relative 'directory_view'
require_relative 'helper.rb'

class FilePicker
  def initialize(dir_path)
    @root_path = dir_path
    @dir = DirectoryView.new
    @reader = TTY::Reader.new
    @reader.subscribe(self)
    @user_have_picked = false

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
    @selected += 1 if @selected < @files.length - 1
    redraw
  end

  def keyup(_event)
    @selected -= 1 if @selected.positive?
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

  def change_directory(full_path)
    @current_path = full_path
    @files = order_files(files_in_dir(@current_path))
    @dir.set_directory(@files, @current_path)
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
    (groups[:dots] || []).sort + groups[:files]
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

  def full_path(file_name)
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

  def redraw
    print_in_place(@dir.render(@selected))
  end
end
