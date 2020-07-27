require_relative '../../lib/terminal-file-picker/file_browser_model'

# rubocop:disable Metrics/BlockLength
describe FileBrowserModel do
  describe 'files_in_dir' do
    let(:dir_path) { '' }
    let(:files) { ['.', '..', 'file1.csv', 'dir1', 'file2.txt'] }
    subject { FileBrowserModel.new }

    before(:each) do
      allow(Dir).to receive(:entries).with(dir_path).and_return(files)
      test_time1 = Time.new(2020, 7, 26, 14, 20)
      test_time2 = Time.new(2019, 6, 24, 10, 50)
      test_time3 = Time.new(2018, 4, 20, 5, 25)

      allow(File).to receive(:size).with("#{dir_path}/.").and_return(4_096)
      allow(File).to receive(:size).with("#{dir_path}/..").and_return(4_096)
      allow(File).to receive(:size).with("#{dir_path}/file1.csv").and_return(150)
      allow(File).to receive(:size).with("#{dir_path}/dir1").and_return(15_570)
      allow(File).to receive(:size).with("#{dir_path}/file2.txt").and_return(864_344)

      allow(File).to receive(:mtime).with("#{dir_path}/.").and_return(test_time1)
      allow(File).to receive(:mtime).with("#{dir_path}/..").and_return(test_time2)
      allow(File).to receive(:mtime).with("#{dir_path}/file1.csv").and_return(test_time1)
      allow(File).to receive(:mtime).with("#{dir_path}/dir1").and_return(test_time2)
      allow(File).to receive(:mtime).with("#{dir_path}/file2.txt").and_return(test_time3)
    end

    it 'returns a set of details for all files in directory' do
      expected = [
        ['./', 4_096, '26/07/2020', '14:20'],
        ['../', 4_096, '24/06/2019', '10:50'],
        ['file1.csv', 150, '26/07/2020', '14:20'],
        ['dir1', 15_570, '24/06/2019', '10:50'],
        ['file2.txt', 864_344, '20/04/2018', '05:25']
      ]

      expect(subject.files_in_dir(dir_path)).to eq(expected)
    end

    context 'when a custom date and time format is given' do
      it 'returns date and time modified using a custom format' do
        date_format = '%d-%m-%Y'
        time_format = '%H.%M'
        options = {
          date_format: date_format,
          time_format: time_format
        }

        expected = [
          ['./', 4_096, '26-07-2020', '14.20'],
          ['../', 4_096, '24-06-2019', '10.50'],
          ['file1.csv', 150, '26-07-2020', '14.20'],
          ['dir1', 15_570, '24-06-2019', '10.50'],
          ['file2.txt', 864_344, '20-04-2018', '05.25']
        ]

        expect(subject.files_in_dir(dir_path, options)).to eq(expected)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
