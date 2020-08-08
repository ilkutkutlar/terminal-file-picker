require_relative '../../lib/terminal-file-picker/file_browser_model'

# rubocop:disable Metrics/BlockLength
describe FileBrowserModel do
  subject { FileBrowserModel.new(starting_path) }

  let(:starting_path) { '/test_dir' }
  let(:files) do
    [
      ['./', 4_096, '26/07/2020', '14:20'],
      ['../', 4_096, '24/06/2019', '10:50'],
      ['file1.csv', 150, '26/07/2020', '14:20'],
      ['dir1/', 15_570, '24/06/2019', '10:50'],
      ['file2.txt', 864_344, '20/04/2018', '05:25']
    ]
  end

  def mock_dirs
    dirs = [starting_path,
            "#{starting_path}/.",
            "#{starting_path}/..",
            "#{starting_path}/dir1"]

    allow(File).to receive(:directory?).and_call_original
    dirs.each do |dir|
      allow(File).to receive(:directory?).with(dir).and_return(true)
    end
  end

  before(:each) do
    mock_dir_entries(starting_path, files)
    mock_file_sizes(files, starting_path)
    mock_file_modified_times(files, starting_path)
    mock_dirs
  end

  describe '#files_in_dir' do
    it 'returns a set of details for all files in directory' do
      expected = files
      expect(subject.files_in_dir).to eq(expected)
    end

    context 'when a custom date and time format is given' do
      let(:date_time_options) do
        { date_format: '%d-%m-%Y', time_format: '%H.%M' }
      end
      subject { FileBrowserModel.new(starting_path, date_time_options) }

      it 'returns date and time modified using a custom format' do
        expected = [
          ['./', 4_096, '26-07-2020', '14.20'],
          ['../', 4_096, '24-06-2019', '10.50'],
          ['file1.csv', 150, '26-07-2020', '14.20'],
          ['dir1/', 15_570, '24-06-2019', '10.50'],
          ['file2.txt', 864_344, '20-04-2018', '05.25']
        ]

        expect(subject.files_in_dir).to eq(expected)
      end
    end
  end

  describe '#path_rel_to_start' do
    it 'returns the path to given file relative to starting path' do
      allow(subject).to receive(:current_path).and_return('/test_dir')
      expect(subject.path_rel_to_start('.')).to eq('/test_dir/.')
      expect(subject.path_rel_to_start('test_file')).to eq('/test_dir/test_file')
    end
  end

  describe '#order_files' do
    it 'orders files so that . and .. appear at the start' do
      unordered_files = [
        ['file1.csv', 150, '26/07/2020', '14:20'],
        ['dir1/', 15_570, '24/06/2019', '10:50'],
        ['file2.txt', 864_344, '20/04/2018', '05:25'],
        ['./', 4_096, '26/07/2020', '14:20'],
        ['../', 4_096, '24/06/2019', '10:50']
      ]
      ordered_files = [
        ['./', 4_096, '26/07/2020', '14:20'],
        ['../', 4_096, '24/06/2019', '10:50'],
        ['file1.csv', 150, '26/07/2020', '14:20'],
        ['dir1/', 15_570, '24/06/2019', '10:50'],
        ['file2.txt', 864_344, '20/04/2018', '05:25']
      ]

      expect(subject.order_files(unordered_files)).to eq(ordered_files)
    end
  end
end
# rubocop:enable Metrics/BlockLength
