require 'tty-cursor'
require 'tty-reader'
require_relative 'directory_view'
require_relative 'helper.rb'

class FilePicker
  def initialize(files, dir_path)
    @files = files
    @dir_path = dir_path

    @reader = TTY::Reader.new
    @selected = 0
    @dir = DirectoryView.new(@files, @dir_path)
    @reader.subscribe(self)
    @user_have_picked = false
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

    print(TTY::Cursor.show)
    print(TTY::Cursor.clear_screen_down)
    "#{@dir_path}/#{@files[@selected].first}"
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
      @user_have_picked = true
    end
  end

  private

  def redraw
    print_in_place(@dir.render(@selected))
  end
end
