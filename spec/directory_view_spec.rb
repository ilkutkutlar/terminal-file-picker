require_relative '../directory_view'

describe 'DirectoryView' do
  let(:dir) { DirectoryView.new }
  let(:files) do 
    [["File 1", "4096", "17/05/2020", "19:39"], 
      ["File 2", "2048", "14/05/2020", "19:00"]]
  end

  describe '#set_directory' do
    it 'sets the viewed directory and the containing files' do
      dir.set_directory(files, "test_directory")

      expect(dir.instance_variable_get(:@files)).to eq(files)
      expect(dir.instance_variable_get(:@dir_path)).to eq("test_directory")
    end
  end

  describe '#render' do
    it 'renders a list of files and directories and highlights selected file' do
      dir.instance_variable_set(:@files, files)
      dir.instance_variable_set(:@dir_path, "test_directory")
      
      expected = "Directory: test_directory\n\n" \
                 "  Name      Size    Date modified    Time modified  \n" \
                 "----------------------------------------------------\n" \
                 "\e[7m  File 1  \e[0m\e[7m  4096  \e[0m\e[7m  17/05/2020     \e[0m\e[7m  19:39          \e[0m\n" \
                 "  File 2    2048    14/05/2020       19:00          "

      expect(dir.render(0)).to eq(expected)
    end
  end
end
