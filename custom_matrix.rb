class CustomMatrix
  def initialize(mat)
    @base = {col: [], row: [], mat: mat}
    sync
  end

  def sync
    @base[:mat].each do |row|
      @base[:row] << row
      row.each_with_index do |el, col_index|
        (@base[:col][col_index] ||= []) << el
      end
    end
    @base
  end

  def []=(row, col, info)
    @base[:mat][row][col] = info
    @base[:col][col][row] = info
    @base[:row][row][col] = info
  end

  def [](row = nil, col = nil)
    return @base[:row][row] if col.nil?
    return @base[:col][col] if row.nil?
    @base[:mat][row][col]
  end
end
