require_relative '../../lib/terminal-file-picker/file_browser_model'

# rubocop:disable Metrics/BlockLength
describe FileBrowserModel do
  describe 'files_in_dir' do
    let(:dir_path) { '' }
    subject { FileBrowserModel.new(dir_path) }

    let(:files) { ['.', '..', 'file1.csv', 'dir1', 'file2.txt'] }
    let(:test_time1) { Time.new(2020, 7, 26, 14, 20) }
    let(:test_time2) { Time.new(2019, 6, 24, 10, 50) }
    let(:test_time3) { Time.new(2018, 4, 20, 5, 25) }

    before(:each) do
      allow(Dir).to receive(:entries).with(dir_path).and_return(files)

      sizes = {
        "#{dir_path}/." => 4_096,
        "#{dir_path}/.." => 4_096,
        "#{dir_path}/file1.csv" => 150,
        "#{dir_path}/dir1" => 15_570,
        "#{dir_path}/file2.txt" => 864_344
      }

      mtimes = {
        "#{dir_path}/." => test_time1,
        "#{dir_path}/.." => test_time2,
        "#{dir_path}/file1.csv" => test_time1,
        "#{dir_path}/dir1" => test_time2,
        "#{dir_path}/file2.txt" => test_time3
      }

      sizes.each do |file, size|
        allow(File).to receive(:size).with(file).and_return(size)
      end

      mtimes.each do |file, mtime|
        allow(File).to receive(:mtime).with(file).and_return(mtime)
      end
    end

    it 'returns a set of details for all files in directory' do
      expected = [
        ['./', 4_096, '26/07/2020', '14:20'],
        ['../', 4_096, '24/06/2019', '10:50'],
        ['file1.csv', 150, '26/07/2020', '14:20'],
        ['dir1', 15_570, '24/06/2019', '10:50'],
        ['file2.txt', 864_344, '20/04/2018', '05:25']
      ]

      expect(subject.files_in_dir).to eq(expected)
    end

    context 'when a custom date and time format is given' do
      let(:date_time_options) do
        { date_format: '%d-%m-%Y', time_format: '%H.%M' }
      end
      subject { FileBrowserModel.new(dir_path, date_time_options) }

      it 'returns date and time modified using a custom format' do
        expected = [
          ['./', 4_096, '26-07-2020', '14.20'],
          ['../', 4_096, '24-06-2019', '10.50'],
          ['file1.csv', 150, '26-07-2020', '14.20'],
          ['dir1', 15_570, '24-06-2019', '10.50'],
          ['file2.txt', 864_344, '20-04-2018', '05.25']
        ]

        expect(subject.files_in_dir).to eq(expected)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
