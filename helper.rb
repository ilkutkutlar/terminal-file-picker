require 'pastel'

def print_in_place(text)
  line_count = text.count("\n")
  cursor = TTY::Cursor
  print(text + cursor.column(1) + cursor.up(line_count))
end

def select(text)
  Pastel.new.decorate(text, :inverse)
end
