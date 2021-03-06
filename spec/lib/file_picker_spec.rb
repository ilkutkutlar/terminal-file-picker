require_relative '../../lib/terminal-file-picker/file_picker'
require 'time'

# rubocop:disable Metrics/BlockLength
describe FilePicker do
  let(:starting_path) { '/home/test_user' }
  let(:files) do
    [
      ['file_1', '4096', '17/05/2020', '19:39'],
      ['file_2', '2048', '14/05/2020', '19:00']
    ]
  end

  subject { FilePicker.new(starting_path) }
  let(:model) { subject.instance_variable_get(:@model) }

  before do
    mock_file_sizes(files, starting_path)
    mock_file_modified_times(files, starting_path)
    mock_dir_entries(starting_path, files)

    model.instance_variable_set(:@files, files)
    allow(model).to receive(:files_in_dir).and_return(files)
  end

  describe '#pick_file' do
    skip
  end

  describe '#keydown' do
    it 'selects item one below the current one and redraws picker' do
      model.instance_variable_set(:@selected, 0)
      expected = "\e[1GPage: 1/1 | Directory: /home/test_user\n\n" \
                 "  Name      Size (B)    Date modified    Time modified  \n" \
                 "--------------------------------------------------------\n" \
                 "  file_1    4096        17/05/2020       19:39          \n" \
                 "\e[7m" \
                 '  file_2    2048        14/05/2020       19:00          ' \
                 "\e[0m" \
                 "\e[5A\e[1G"

      expect { subject.keydown(nil) }.to output(expected).to_stdout
      expect(model.instance_variable_get(:@selected)).to eq(1)
    end

    context 'selected item is outside current picker page' do
      it 'clears current page and draws the page where new selected item is' do
        view = subject.instance_variable_get(:@view)
        view.instance_variable_set(:@files_per_page, 1)
        subject.instance_variable_set(:@view, view)

        model.instance_variable_set(:@selected, 0)

        expected = "\e[J\e[1GPage: 2/2 | Directory: /home/test_user\n\n" \
                   "  Name      Size (B)    Date modified    Time modified  \n" \
                   "--------------------------------------------------------\n" \
                   "\e[7m" \
                   '  file_2    2048        14/05/2020       19:00          ' \
                   "\e[0m" \
                   "\e[4A\e[1G"

        expect { subject.keydown(nil) }.to output(expected).to_stdout
        expect(model.instance_variable_get(:@page)).to eq(1)
        expect(model.instance_variable_get(:@selected)).to eq(1)
      end
    end
  end

  describe '#keyup' do
    it 'selects item one above the current one and redraws picker' do
      model.instance_variable_set(:@selected, 1)
      expected = "\e[1GPage: 1/1 | Directory: /home/test_user\n\n" \
                 "  Name      Size (B)    Date modified    Time modified  \n" \
                 "--------------------------------------------------------\n" \
                 "\e[7m" \
                 '  file_1    4096        17/05/2020       19:39          ' \
                 "\e[0m\n" \
                 '  file_2    2048        14/05/2020       19:00          ' \
                 "\e[5A\e[1G"

      expect { subject.keyup(nil) }.to output(expected).to_stdout
      expect(model.selected).to eq(0)
    end

    context 'selected item is outside current picker page' do
      it 'clears current page and draws the page where new selected item is' do
        view = subject.instance_variable_get(:@view)
        view.instance_variable_set(:@files_per_page, 1)
        subject.instance_variable_set(:@view, view)

        model.instance_variable_set(:@page, 1)
        model.instance_variable_set(:@selected, 1)

        expected = "\e[J\e[1GPage: 1/2 | Directory: /home/test_user\n\n" \
                   "  Name      Size (B)    Date modified    Time modified  \n" \
                   "--------------------------------------------------------\n" \
                   "\e[7m" \
                   '  file_1    4096        17/05/2020       19:39          ' \
                   "\e[0m" \
                   "\e[4A\e[1G"

        expect { subject.keyup(nil) }.to output(expected).to_stdout

        expect(model.page).to eq(0)
        expect(model.selected).to eq(0)
      end
    end
  end

  describe '#keypress' do
    context 'enter key is pressed' do
      context 'selected item is a directory' do
        it 'changes current directory to selected and redraws picker' do
          # 0th item is 'file_1'
          model.instance_variable_set(:@selected, 0)
          model.instance_variable_set(:@current_path, starting_path)

          event = double
          allow(event).to receive(:value).and_return("\r")

          file_path = "#{starting_path}/file_1"

          allow(File).to receive(:directory?).and_call_original
          allow(File).to receive(:directory?).with(file_path).and_return(true)

          expected = "\e[J\e[1GPage: 1/1 | Directory: /home/test_user/file_1\n\n" \
                 "  Name      Size (B)    Date modified    Time modified  \n" \
                 "--------------------------------------------------------\n" \
                 "\e[7m" \
                 '  file_1    4096        17/05/2020       19:39          ' \
                 "\e[0m\n" \
                 '  file_2    2048        14/05/2020       19:00          ' \
                 "\e[5A\e[1G"

          expect { subject.keypress(event) }.to output(expected).to_stdout
        end
      end

      context 'selected item is a file' do
        it 'sets flag to indicate user have picked a file' do
          subject.instance_variable_set(:@selected, 0)
          subject.instance_variable_set(:@current_path, starting_path)

          event = double
          allow(event).to receive(:value).and_return("\r")

          file_path = "#{starting_path}/file_1"

          allow(File).to receive(:directory?).and_call_original
          allow(File).to receive(:directory?).with(file_path).and_return(false)

          expect { subject.keypress(event) }.to_not output.to_stdout
          expect(subject.instance_variable_get(:@user_have_picked)).to eq(true)
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
