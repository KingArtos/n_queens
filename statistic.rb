class Statistic
  def self.calc(total_count = 1, partial_count = 1, total_key = nil, partial_key = nil)
    puts "#{total_key || 'total'}:  #{total_count}"
    puts "#{partial_key || 'partial'}: #{partial_count}"
    puts "percentage: #{partial_count/total_count.to_f}"
    puts ">>"
  end

  def self.sum_matrix(matrix = [[],[]])
    matrix.reduce({sum: {}, index: 0}) do |res, ul|
      ul.each do |el|
        res[:sum][el] ||= Array.new(list.length, 0)
        res[:sum][el][res[:index]] += 1
      end
      res[:index] += 1
      res
    end
  end

  def self.check_matrix(matrix = [[], []])
    puts "matrix: #{matrix.length} times"
    matrix_length = matrix_length
    puts "element -> " if matrix.length > 0
    sum_matrix(matrix).each{|el, values| puts "#{el} -> #{custom_join(values, 15, ' ')}" }
  end


  def self.check_array(list = [])
    puts "List length: #{list.length} ocurrences"
    puts "element -> ocurrences" if list.length > 0
    (count_by(list){|x| x}).each{ |el, ocurrence| puts "#{el} -> #{ocurrence}" }
    puts ">>"
  end

  def self.custom_join(list = [], amount = 0, key = " ")
    list.reduce("") do |res, el|
      res += (amount - el.to_s.length).times.reduce(el.to_s){|r,s| r += key} + " | "
    end
  end

  def self.count_by(list, &block)
    Hash[list.group_by(&block).map { |key,vals| [key, vals.size] }]
  end
end