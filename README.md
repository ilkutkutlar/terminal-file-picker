# Terminal File Picker

This gem shows an interactive terminal file picker to user, allowing them to browse their files with arrow keys and file. The picked file path is then returned to the calling program. The file picker is completely text-based and can be used with a terminal or terminal emulator. It is essentially a terminal version of a GUI file choosing dialogue.

The gem is useful when your program needs to accept a file path as input and you want a more user-friendly option than asking user to find out the file path and enter it as text.

The gem does not rely on the Curses library and instead uses the [TTY toolkit](https://github.com/piotrmurach/tty), which has cross platform support and support for many types of terminals/terminal emulators. Therefore this gem should also have the same level of support.
