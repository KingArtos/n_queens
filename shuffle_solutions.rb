# ShuffleSolutions.new(X).run
class ShuffleSolutions
  def initialize(size = 8, threads = 1)
    @interactions = {}
    @structure = size.times.to_a
    @max_interaction = 1.upto(size).reduce(:*)
    @solutions = []
    @max_next = 10
    @threads = threads
  end

  def statistic
    puts "Coverage: #{percent coverage}"
    puts "Solutions in coverage: #{percent solutions}"
  end

  def stop
    @stop = true
  end

  def run
    @stop = false
    @threads.times.each do
      Thread.new do
        loop do
          solution = next_solution(@structure, 0)
          break if check_break(solution)
          @solutions << solution if solution?(solution)
        end
      end
    end
  end

  def solutions_count
    @solutions.count
  end

  def prints
    @solutions.each do |solution|
      print(solution)
      puts '____________________'
    end.count
  end

  def solution?(solution)
    calc_diagonals(solution).find do |res|
      res.last.uniq.count < solution.count
    end.nil?
  end

  private

  def check_break(solution)
    solution.nil? || max? || @stop
  end

  def print(solution = @solution)
    puts formated_solution(solution)
  end

  def coverage
    interactions_count / @max_interaction
  end

  def solutions
    @solutions.count / interactions_count
  end

  def interactions_count
    @interactions_count ||= @interactions.count.to_f
  end

  def percent(num = 1.0)
    num * 100
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
