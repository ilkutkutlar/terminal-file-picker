require_relative '../../lib/terminal-file-picker/file_browser_view'

describe FileBrowserView do
  let(:files) do
    [['File 1', '4096', '17/05/2020', '19:39'],
     ['File 2', '2048', '14/05/2020', '19:00']]
  end

  describe '#render' do
    it 'renders a list of files and directories and highlights selected file' do
      dir = FileBrowserView.new
      expected = "Page: 1/1 | Directory: test_directory\n\n" \
                 "  Name      Size (B)    Date modified    Time modified  \n" \
                 "--------------------------------------------------------\n" \
                 "\e[7m  File 1    4096        " \
                 "17/05/2020       19:39          \e[0m\n" \
                 '  File 2    2048        14/05/2020       19:00          '

      expect(dir.render('test_directory', files, 0, 0)).to eq(expected)
    end

    it 'renders with custom header if user supplied it' do
      header = ['the name', 'the size', 'the date', 'the time']
      dir = FileBrowserView.new(header: header)

      expected = "Page: 1/1 | Directory: test_directory\n\n" \
                 "  the name    the size    the date      the time  \n" \
                 "--------------------------------------------------\n" \
                 "\e[7m  File 1      4096        " \
                 "17/05/2020    19:39     \e[0m\n" \
                 '  File 2      2048        14/05/2020    19:00     '

      expect(dir.render('test_directory', files, 0, 0)).to eq(expected)
    end

    it 'renders with custom "Directory" label if user supplied it' do
      dir = FileBrowserView.new(dir_label: 'the directory')

      expected = "Page: 1/1 | the directory: test_directory\n\n" \
                 "  Name      Size (B)    Date modified    Time modified  \n" \
                 "--------------------------------------------------------\n" \
                 "\e[7m  File 1    4096        " \
                 "17/05/2020       19:39          \e[0m\n" \
                 '  File 2    2048        14/05/2020       19:00          '

      expect(dir.render('test_directory', files, 0, 0)).to eq(expected)
    end

    it 'renders with custom horizontal paddings if user supplied them' do
      dir = FileBrowserView.new(left_pad: 1, right_pad: 1)

      expected = "Page: 1/1 | Directory: test_directory\n\n" \
                 " Name    Size (B)  Date modified  Time modified \n" \
                 "------------------------------------------------\n" \
                 "\e[7m File 1  4096      " \
                 "17/05/2020     19:39         \e[0m\n" \
                 ' File 2  2048      14/05/2020     19:00         '

      expect(dir.render('test_directory', files, 0, 0)).to eq(expected)
    end

    it 'renders with custom "Page" label if user supplied one' do
      dir = FileBrowserView.new(page_label: 'the page')

      expected = "the page: 1/1 | Directory: test_directory\n\n" \
                 "  Name      Size (B)    Date modified    Time modified  \n" \
                 "--------------------------------------------------------\n" \
                 "\e[7m  File 1    4096        " \
                 "17/05/2020       19:39          \e[0m\n" \
                 '  File 2    2048        14/05/2020       19:00          '

      expect(dir.render('test_directory', files, 0, 0)).to eq(expected)
    end

    it 'hides info line if the user wants it hidden' do
      dir = FileBrowserView.new(show_info_line: false)

      expected = "  Name      Size (B)    Date modified    Time modified  \n" \
                 "--------------------------------------------------------\n" \
                 "\e[7m  File 1    4096        " \
                 "17/05/2020       19:39          \e[0m\n" \
                 '  File 2    2048        14/05/2020       19:00          '

      expect(dir.render('test_directory', files, 0, 0)).to eq(expected)
    end

    it 'renders info line below table if the user wants to' do
      dir = FileBrowserView.new(info_line_position: :bottom)

      expected = "  Name      Size (B)    Date modified    Time modified  \n"\
                 "--------------------------------------------------------\n"\
                 "\e[7m  File 1    4096        " \
                 "17/05/2020       19:39          \e[0m\n" \
                 "  File 2    2048        14/05/2020       19:00          \n\n"\
                 'Page: 1/1 | Directory: test_directory'

      expect(dir.render('test_directory', files, 0, 0)).to eq(expected)
    end

    it 'paginates files and renders files in a specific page' do
      dir = FileBrowserView.new(files_per_page: 1)

      expected = "Page: 2/2 | Directory: test_directory\n\n" \
                 "  Name      Size (B)    Date modified    Time modified  \n" \
                 "--------------------------------------------------------\n" \
                 '  File 2    2048        14/05/2020       19:00          '

      expect(dir.render('test_directory', files, 0, 1)).to eq(expected)
    end

    it 'truncates browser if it is larger than the width of the screen' do
      dir = FileBrowserView.new
      allow(dir).to receive(:screen_width).and_return(30)


      expected = "Page: 1/1 | Directory: test_di\n\n" \
                 "  Name      Size (B)    Date m\n" \
                 "------------------------------\n" \
                 "\e[7m  File 1    4096        17/05/\e[0m\n" \
                 '  File 2    2048        14/05/'

      expect(dir.render('test_directory', files, 0, 0)).to eq(expected)
    end
  end
end
