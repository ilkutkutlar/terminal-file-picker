require_relative '../helper'

describe 'print_in_place' do
  it 'prints text and returns cursor to the start of the text' do
    expected = "\e[1GHello\nHi\e[1A\e[1G"
    expect { print_in_place("Hello\nHi") }
      .to output(expected).to_stdout
  end
end

describe 'select' do
  it 'returns the text with formatting to make it appear selected' do
    expect(select('test')).to eq("\e[7mtest\e[0m")
  end
end
