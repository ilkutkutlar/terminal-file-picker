require_relative '../../lib/terminal-file-picker/file_browser_model'

# rubocop:disable Metrics/BlockLength
describe FileBrowserModel do
  subject { FileBrowserModel.new(starting_path) }

  let(:starting_path) { 'test_dir' }
  let(:files) { ['.', '..', 'file1.csv', 'dir1', 'file2.txt'] }
  let(:test_time1) { Time.new(2020, 7, 26, 14, 20) }
  let(:test_time2) { Time.new(2019, 6, 24, 10, 50) }
  let(:test_time3) { Time.new(2018, 4, 20, 5, 25) }

  def mock_file_sizes
    sizes = {
      "#{starting_path}/." => 4_096,
      "#{starting_path}/.." => 4_096,
      "#{starting_path}/file1.csv" => 150,
      "#{starting_path}/dir1" => 15_570,
      "#{starting_path}/file2.txt" => 864_344
    }

    sizes.each do |file, size|
      allow(File).to receive(:size).with(file).and_return(size)
    end
  end

  def mock_file_modified_times
    mtimes = {
      "#{starting_path}/." => test_time1,
      "#{starting_path}/.." => test_time2,
      "#{starting_path}/file1.csv" => test_time1,
      "#{starting_path}/dir1" => test_time2,
      "#{starting_path}/file2.txt" => test_time3
    }

    mtimes.each do |file, mtime|
      allow(File).to receive(:mtime).with(file).and_return(mtime)
    end
  end

  before(:each) do
    allow(Dir).to receive(:entries).with(starting_path).and_return(files)
    mock_file_sizes
    mock_file_modified_times

    allow(File).to receive(:directory?).and_call_original
    allow(File).to receive(:directory?).with("#{starting_path}/.").and_return(true)
    allow(File).to receive(:directory?).with("#{starting_path}/..").and_return(true)
    allow(File).to receive(:directory?).with("#{starting_path}/dir1").and_return(true)
  end

  describe '#files_in_dir' do
    it 'returns a set of details for all files in directory' do
      expected = [
        ['./', 4_096, '26/07/2020', '14:20'],
        ['../', 4_096, '24/06/2019', '10:50'],
        ['file1.csv', 150, '26/07/2020', '14:20'],
        ['dir1/', 15_570, '24/06/2019', '10:50'],
        ['file2.txt', 864_344, '20/04/2018', '05:25']
      ]

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

  describe '#file_path' do
    context 'file name is current directory ("." or "./")' do
      it 'returns the current path relative to starting path' do
        allow(subject).to receive(:current_path).and_return('test_dir')
        expect(subject.file_path('./')).to eq('test_dir')
        expect(subject.file_path('.')).to eq('test_dir')
      end
    end

    context 'file name is anything else except current directory' do
      it 'returns the path to given file relative to starting path' do
        allow(subject).to receive(:current_path).and_return('test_dir')
        expect(subject.file_path('test_file')).to eq('test_dir/test_file')
      end
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
