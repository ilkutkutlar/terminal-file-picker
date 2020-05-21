# Terminal File Picker

This gem shows an interactive terminal file picker to user, allowing them to browse their files with arrow keys and file. The picked file path is then returned to the calling program. The file picker is completely text-based and can be used with a terminal or terminal emulator. It is essentially a terminal version of a GUI file choosing dialogue.

The gem is useful when your program needs to accept a file path as input and you want a more user-friendly option than asking user to find out the file path and enter it as text.

The gem does not rely on the Curses library and instead uses the [TTY toolkit](https://github.com/piotrmurach/tty), which has cross platform support and support for many types of terminals/terminal emulators. Therefore this gem should also have the same level of support.

# Usage

Simple usage:

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

The simple file picker looks like this:

```
Page: 1/2 | Directory: .

  Name                            Size    Date modified    Time modified
  --------------------------------------------------------------------------
  .                               4096    21-05-2020       00:53
  ..                              4096    18-05-2020       22:45
  terminal-file-picker.rb         113     21-05-2020       00:19
  .gitignore                      20      17-05-2020       01:04
  LICENSE                         1068    17-05-2020       22:42
  README.md                       916     21-05-2020       00:53
  .rubocop.yml                    497     17-05-2020       19:15
  terminal-file-picker.gemspec    581     17-05-2020       22:24
  .git/                           4096    21-05-2020       00:51
  spec/                           4096    21-05-2020       00:47
```

There are some options to customise the look and feel of the file picker (all options do have default values, so all are optional):

```rb
# The table headers can be changed (e.g. if you want shorter headers
# or for internationalisation).
FilePicker.new('.', 
               header: ["Nm.", "Sz.", "Date md.", "Time md."])


# You can changes the label which by default says "Directory" in the info line.
FilePicker.new('.', dir_label: 'Dir')


# You can change the label which by default says "Page" in the info line.
FilePicker.new('.', page_label: 'Pg')


# You can change paddings of the table (in terms of number of spaces)
FilePicker.new('.', left_pad: 1, right_pad: 1)


# The file picker automatically paginates files. You can set how
# many files there should be in each page (10 by default)
FilePicker.new('.', files_per_page: 20)


# You can choose to hide the info line (the line which shows the current
# directory and current page)
FilePicker.new('.', show_info_line: false)


# You can also change the position of the info line (valid values are
# :top or :bottom. :top is the default)
FilePicker.new('.', info_line_position: :bottom)
```
