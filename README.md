# Terminal File Picker

[![Gem Version](https://badge.fury.io/rb/terminal-file-picker.svg)](https://badge.fury.io/rb/terminal-file-picker)

This gem shows an interactive terminal file picker to user, allowing them to browse their files with arrow keys and file. The picked file path is then returned to the calling program. The file picker is completely text-based and can be used with a terminal or terminal emulator. It is essentially a terminal version of a GUI file choosing dialogue.

The gem is useful when your program needs to accept a file path as input and you want a more user-friendly option than asking user to find out the file path and enter it as text.

The gem does not rely on the Curses library and instead uses the [TTY toolkit](https://github.com/piotrmurach/tty), which has cross platform support and support for many types of terminals/terminal emulators. Therefore this gem should also have the same level of support.

# Installation

```rb
gem install 'terminal-file-picker'
```

or add it to your project's `Gemfile`:

```rb
gem 'terminal-file-picker'
```

# Simple Usage

```rb
# Only required argument is the "root path". The user starts
# navigating from the root path and the returned path of
# the chosen file is relative to this root path.
picker = FilePicker.new('.')

# This brings up the interactive file picker. Once the user
# has picked a file, the picker is cleared from screen and
# the chosen file path returned.

# If user picks a directory, instead of returning its path,
# the files inside the chosen directory is shown instead.
puts(picker.pick_file)
```

# Options

There are some options to customise the look and feel of the file picker (all options do have default values, so all are optional)

The table headers can be changed (e.g. for internationalisation of if you want shorter headers).
```rb
FilePicker.new('.', header: ["Nm.", "Sz.", "Date md.", "Time md."])
```

You can change the current directory label which by default says "Directory" in the info line.

```rb
FilePicker.new('.', dir_label: 'Dir')
```

You can change current page label which by default says "Page" in the info line.

```rb
FilePicker.new('.', page_label: 'Pg')
```

You can change paddings of the table (in terms of number of spaces)

```rb
FilePicker.new('.', left_pad: 1, right_pad: 1)
```

The file picker automatically paginates files. You can set how many files there should be in each page (10 by default)

```rb
FilePicker.new('.', files_per_page: 20)
```

You can choose to hide the info line (the line which shows the current directory and current page)

```rb
FilePicker.new('.', show_info_line: false)
```

You can also change the position of the info line (valid values are :top or :bottom. :top is the default)

```rb
FilePicker.new('.', info_line_position: :bottom)
```

You can change the date and time format of date modified and time modified columns. The format can be specified using the same format accepted by the built-in `strftime` function.

```rb
FilePicker.new('.',  date_format: '%d-%m-%Y', time_format: '%H.%m')
```
