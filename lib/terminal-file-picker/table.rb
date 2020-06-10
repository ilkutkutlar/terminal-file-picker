class Table
  def initialize(header, data, left_pad, right_pad)
    @header = header
    @data = data
    @left_pad = left_pad
    @right_pad = right_pad   
    @col_sizes = table_column_sizes
  end

  def render
    rendered_header = render_row(@header)
    rendered_data = @data.map {|row| render_row(row)}.join("\n")
    border = '-' * total_row_size
    [rendered_header, border, rendered_data].join("\n")
  end

  def total_row_size
    total_padding_size = (@left_pad + @right_pad) * @header.length
    @col_sizes.sum + total_padding_size
  end

  private

  def render_row(row)
    left_pad_str = ' ' * @left_pad
    right_pad_str = ' ' * @right_pad

    justified_cols = row.zip(@col_sizes).map do |col, col_size|
      col.to_s.ljust(col_size)
    end

    justified_cols_str = justified_cols.join("#{left_pad_str}#{right_pad_str}")
    "#{left_pad_str}#{justified_cols_str}#{right_pad_str}"
  end

  def table_column_sizes
    table_data = [@header] + @data
    col_count = table_data.first.length

    (0..col_count - 1).map do |col|
      table_data.map do |row|
        row[col].to_s.length
      end.max
    end
  end
end
