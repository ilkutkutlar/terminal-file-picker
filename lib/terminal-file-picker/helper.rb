require 'pastel'
require 'tty-cursor'

# Misc. helper methods which accomplish some common tasks.
module Helper
  class << self
    def print_in_place(text)
      line_count = text.count("\n")
      cursor = TTY::Cursor

      in_place = cursor.column(1)
      in_place << text
      in_place << cursor.up(line_count)
      in_place << cursor.column(1)

      print(in_place)
    end

    def highlight(text)
      Pastel.new.decorate(text, :inverse)
    end
  end
end
