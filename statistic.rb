class Statistic
  def self.calc(total_count = 1, partial_count = 1, total_key = nil, partial_key = nil)
    puts "#{total_key || 'total'}:  #{total_count}"
    puts "#{partial_key || 'partial'}: #{partial_count}"
    puts "percentage: #{partial_count/total_count.to_f}"
    puts ">>\\n"
  end
end