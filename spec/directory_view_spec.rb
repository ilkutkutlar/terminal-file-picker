require_relative '../lib/directory_view'

describe 'DirectoryView' do
  let(:dir) { DirectoryView.new }
  let(:files) do
    [['File 1', '4096', '17/05/2020', '19:39'],
     ['File 2', '2048', '14/05/2020', '19:00']]
  end

  describe '#render' do
    it 'renders a list of files and directories and highlights selected file' do
      expected = "Page: 1/1 | Directory: test_directory\n\n" \
                 "  Name      Size    Date modified    Time modified  \n" \
                 "----------------------------------------------------\n" \
                 "\e[7m  File 1  \e[0m\e[7m  4096  \e[0m\e[7m  " \
                 "17/05/2020     \e[0m\e[7m  19:39          \e[0m\n" \
                 '  File 2    2048    14/05/2020       19:00          '

      expect(dir.render('test_directory', 
                        files, 0, 0)).to eq(expected)
    end

    it 'renders with custom header if user supplied it' do
      header = ['the name', 'the size', 'the date', 'the time']
      custom_header_dir = DirectoryView.new(header: header)

      expected = "Page: 1/1 | Directory: test_directory\n\n" \
                 "  the name    the size    the date      the time  \n" \
                 "--------------------------------------------------\n" \
                 "\e[7m  File 1    \e[0m\e[7m  4096      \e[0m\e[7m  " \
                 "17/05/2020  \e[0m\e[7m  19:39     \e[0m\n" \
                 '  File 2      2048        14/05/2020    19:00     '

      expect(custom_header_dir.render('test_directory',
                                      files, 0, 0)).to eq(expected)
    end

    it 'renders with custom "Directory" label if user supplied it' do
      custom_dir_label_dir = DirectoryView.new(dir_label: 'the directory')

      expected = "Page: 1/1 | the directory: test_directory\n\n" \
                 "  Name      Size    Date modified    Time modified  \n" \
                 "----------------------------------------------------\n" \
                 "\e[7m  File 1  \e[0m\e[7m  4096  \e[0m\e[7m  " \
                 "17/05/2020     \e[0m\e[7m  19:39          \e[0m\n" \
                 '  File 2    2048    14/05/2020       19:00          '

      expect(custom_dir_label_dir.render('test_directory',
                                         files, 0, 0)).to eq(expected)
    end

    it 'renders with custom horizontal paddings if user supplied them' do
      custom_padding_dir = DirectoryView.new(left_pad: 1, right_pad: 1)

      expected = "Page: 1/1 | Directory: test_directory\n\n" \
                 " Name    Size  Date modified  Time modified \n" \
                 "--------------------------------------------\n" \
                 "\e[7m File 1 \e[0m\e[7m 4096 \e[0m\e[7m " \
                 "17/05/2020    \e[0m\e[7m 19:39         \e[0m\n" \
                 ' File 2  2048  14/05/2020     19:00         '

      expect(custom_padding_dir.render('test_directory',
                                       files, 0, 0)).to eq(expected)
    end

    it 'renders with custom "Page" label if user supplied one' do
      custom_page_label_dir = DirectoryView.new(page_label: 'the page')

      expected = "the page: 1/1 | Directory: test_directory\n\n" \
                 "  Name      Size    Date modified    Time modified  \n" \
                 "----------------------------------------------------\n" \
                 "\e[7m  File 1  \e[0m\e[7m  4096  \e[0m\e[7m  " \
                 "17/05/2020     \e[0m\e[7m  19:39          \e[0m\n" \
                 '  File 2    2048    14/05/2020       19:00          '

      expect(custom_page_label_dir.render('test_directory',
                                         files, 0, 0)).to eq(expected)
      
    end

    it 'paginates files and renders files in a specific page' do
      page_dir = DirectoryView.new(files_per_page: 1)

      expected = "Page: 2/2 | Directory: test_directory\n\n" \
                 "  Name      Size    Date modified    Time modified  \n" \
                 "----------------------------------------------------\n" \
                 "  File 2    2048    14/05/2020       19:00          "

      expect(page_dir.render('test_directory',
                             files, 0, 1)).to eq(expected)
    end
  end
end
