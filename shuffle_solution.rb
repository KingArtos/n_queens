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
          solution = next_solution(@structure, 0)
          break if check_break(solution)
          @solutions << solution if solution?(solution)
        end
        @threads_running -= 1
      end
    end
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

  private

  def check_break(solution)
    solution.nil? || max? || @stop
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

  def next_solution(structure, current_next)
    @acc << current_next
    solution = structure.shuffle
    current_next += 1
    if duplicated?(solution)
      next_solution(structure, current_next) if may_next?(current_next)
    else
      save_solution(solution)
      solution
    end
  end

  def save_solution(solution)
    @interactions[structure_key(solution)] = 0
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
