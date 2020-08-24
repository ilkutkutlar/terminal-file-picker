require 'tty-cursor'
require 'tty-reader'
require_relative 'file_browser_view'
require_relative 'helper'
require_relative 'file_browser_model'

# Responsible for keeping the state of the interactive file picker.
# Also responds to user input to modify the state and redraw
# file picker to reflect new state.
class FilePicker
  def initialize(start_dir_path, options = {})
    @model = FileBrowserModel.new(start_dir_path, options)
    @view = FileBrowserView.new(options)
    @reader = TTY::Reader.new(interrupt: :exit)
    @reader.subscribe(self)
    @cursor = TTY::Cursor
    @user_have_picked = false

    absolute_start_path = File.absolute_path(start_dir_path)
    change_directory(absolute_start_path)
  end

  def pick_file
    @user_have_picked = false
    redraw(false)

    @cursor.invisible do
      @reader.read_keypress until @user_have_picked
    end

    print(@cursor.clear_screen_down)
    @model.selected_absolute_path
  end

  def keydown(_event)
    @model.selected += 1 unless selected_at_bottom?
    if selected_below_page?
      @model.page += 1
      print(@cursor.clear_screen_down)
    end
    redraw(true)
  end

  def keyup(_event)
    @model.selected -= 1 unless selected_at_top?
    if selected_above_page?
      @model.page -= 1
      print(@cursor.clear_screen_down)
    end
    redraw(true)
  end

  def keypress(event)
    case event.value
    when "\r"
      selected = @model.selected_absolute_path

      if File.directory?(selected)
        change_directory(selected)
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

  def change_directory(absolute_file_path)
    @model.current_path = absolute_file_path
    @model.page = 0
    @model.selected = 0
    @model.files = @model.order_files(@model.files_in_dir)
  end

  def redraw(use_cache)
    rendered = @view.render(@model.current_path,
                            @model.files,
                            @model.selected,
                            @model.page,
                            use_cache)
    Helper.print_in_place(rendered)
  end

  def selected_at_top?
    @model.selected.zero?
  end

  def selected_at_bottom?
    @model.selected == @model.files.length - 1
  end

  def selected_above_page?
    @model.selected < (@model.page * @view.files_per_page)
  end

  def selected_below_page?
    @model.selected > (@model.page * @view.files_per_page) + @view.files_per_page - 1
  end
end
