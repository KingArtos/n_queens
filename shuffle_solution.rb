require './statistic'

# ShuffleSolutions.new(X).run
class ShuffleSolution

  attr_reader :solutions, :interactions, :threads_running, :acc

  def initialize(size = 8, threads = 1)
    @interactions = {}
    @structure = size.times.to_a
    @max_interaction = 1.upto(size).reduce(:*)
    @solutions = []
    @max_next = 10
    @threads = threads
    @threads_running = 0
    @acc = []
  end

  def info
    Statistic.check_array(@acc)
    Statistic.calc(@max_interaction, @interactions.length, 'max interactions', 'analyzed interactions')
    Statistic.calc(@interactions.length, @solutions.length, 'analyzed interations', 'approved interactions')
  end

  def stop
    @stop = true
  end

  def run(threads_count = @threads)
    @stop = false
    threads_count.times.each do
      Thread.new do
        @threads_running += 1
        loop do
          solutions = next_solutions(@structure, 0)
          break if check_break(solutions)
          solutions.each{ |solution| @solutions << solution if solution?(solution) }
        end
        @threads_running -= 1
      end
    end
    @solutions.uniq!
  end

  def prints(solutions = @solutions)
    solutions.each do |solution|
      puts '....................'
      puts solution.to_s
      puts '....................'
      print(solution)
    end.count
  end

  def solution?(solution)
    calc_diagonals(solution).find do |res|
      res.last.uniq.count < solution.count
    end.nil?
  end

  def print(solution = @solution)
    puts formated_solution(solution)
  end

  def other_possibility(solution = [], conventional = true)
    max_length = (solution.length - 1)
    output = []
    if conventional
      (solution.length/2.0).round.times do |i|
        output[i] = solution[max_length - i]
        output[max_length - i] = solution[i]
      end
    else
      solution.length.times do |i|
        output[i] = (solution[i] - max_length).abs
      end
    end
    output
  end

  private

  def check_break(solutions)
    solutions.nil? || max? || @stop
  end

  def calc_diagonals(solution)
    solution.reduce(sub: [], sum: []) do |res, el|
      res[:sum] << el + solution.index(el)
      res[:sub] << el - solution.index(el)
      res
    end
  end

  def formated_solution(solution)
    solution.map do |i|
      mat = Array.new(solution.size, '-')
      mat[i] = 'Q'
      mat.join(' ')
    end
  end

  def next_solutions(structure, current_next)
    @acc << current_next
    solution = structure.shuffle
    current_next += 1
    if duplicated?(solution)
      next_solutions(structure, current_next) if may_next?(current_next)
    else
      all_possibilities(solution)
    end
  end

  def all_possibilities(solution)
    s0 = solution
    s1 = other_possibility(s0)
    s2 = other_possibility(s1, false)
    s3 = other_possibility(s2)
    [s0, s1, s2, s3].map{|possible_solution| save_solution(possible_solution)}
  end

  def save_solution(solution)
    @interactions[structure_key(solution)] = 0
    solution
  end

  def duplicated?(solution)
    !@interactions[structure_key(solution)].nil?
  end

  def structure_key(solution)
    solution.join
  end

  def may_next?(current_next)
    current_next < @max_next
  end

  def max?
    @interactions.size >= @max_interaction
  end
end
