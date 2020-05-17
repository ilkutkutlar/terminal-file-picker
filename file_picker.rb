require 'tty-cursor'
require 'pry'
require 'tty-reader'
require_relative 'directory_view'
require_relative 'helper.rb'

class FilePicker
  def initialize(dir_path)
    @root_path = dir_path
    @current_path = dir_path
    @files = files_in_dir(@current_path)

    @reader = TTY::Reader.new
    @selected = 0
    @dir = DirectoryView.new(@files, @current_path)
    @reader.subscribe(self)
    @user_have_picked = false
  end

  def pick_file
    @user_have_picked = false
    print(TTY::Cursor.hide)
    redraw
 
    until @user_have_picked
      # begin
        @reader.read_keypress
      # rescue Exception
        # print(TTY::Cursor.show)
        # exit 0
      # end
    end

    print(TTY::Cursor.clear_screen_down)
    print(TTY::Cursor.show)
    full_path_of_selected
  end

  def keydown(event)
    @selected += 1 if @selected < @files.length - 1
    redraw
  end

  def keyup(event)
    @selected -= 1 if @selected > 0
    redraw
  end

  def keypress(event)
    if event.value == "\r"
      if File.directory?(full_path_of_selected)
        print(TTY::Cursor.clear_screen_down)
        @current_path = full_path_of_selected
        @files = files_in_dir(@current_path)
        @dir.change_directory(@files, @current_path)
        @selected = 0
        redraw
      else
        @user_have_picked = true
      end
    end
  end

  private

  def files_in_dir(dir_path)
    Dir.entries(dir_path).map do |f|
      size_bytes = File.size(full_path(f))
      mtime = File.mtime(full_path(f))
      date_mod = mtime.strftime("%d/%m/%Y")
      time_mod = mtime.strftime("%H:%M")
      name = File.directory?(full_path(f)) ? "#{f}/" : f
      [name, size_bytes, date_mod, time_mod]
    end
  end

  def full_path(file_name)
    "#{@current_path}/#{file_name}"
  end

  def full_path_of_selected
    "#{@current_path}/#{@files[@selected].first}"
  end

  def redraw
    print_in_place(@dir.render(@selected))
  end
end
