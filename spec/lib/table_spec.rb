require_relative '../../lib/terminal-file-picker/table'

# rubocop:disable Metrics/BlockLength
describe Table do
  let(:header) { ['Column 1', 'Column 2', 'Column 3'] }
  let(:data) do
    [
      ['Lorem ipsum', 'dolor sit', 'amet consectetur'],
      ['adipiscing elit', 'Fusce vulputate', 'dui diam'],
      ['eu lacinia', 'libero lobortis', 'sit amet'],
      ['Ut semper', 'ipsum odio', 'ut hendrerit']
    ]
  end
  let(:table) { Table.new(header, data, 2, 2) }

  describe '#render' do
    it 'justifies the data in given rows and renders them as columns' do
      expected = "  Column 1           Column 2           Column 3          \n"\
                 "----------------------------------------------------------\n"\
                 "  Lorem ipsum        dolor sit          amet consectetur  \n"\
                 "  adipiscing elit    Fusce vulputate    dui diam          \n"\
                 "  eu lacinia         libero lobortis    sit amet          \n"\
                 '  Ut semper          ipsum odio         ut hendrerit      '

      expect(table.render).to eq(expected)
    end
  end

  describe 'total_row_size' do
    it 'returns the size of a padded, justified row when it is rendered' do
      expect(table.total_row_size).to eq(58)
    end
  end
end
# rubocop:enable Metrics/BlockLength
