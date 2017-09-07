# BasicSolution.new(X).run
class BasicSolution
  def initialize(size = 8, max_interaction = 1000)
    @interactions = {}
    @structure = size.times.to_a
    @max_interaction = max_interaction
  end

  def update_max(new_max = @max_interaction)
    @max_interaction += new_max
  end

  def run
    solution = @structure
    loop do
      solution = next_solution(@structure)
      break if solution?(solution) || max?
    end
    max? ? 'Not Found' : @solution = solution
  end

  def print
    puts formated_solution(@solution)
  end

  def solution?(solution)
    calc_diagonals(solution).find do |res|
      res.last.uniq.count < solution.count
    end.nil?
  end

  private

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

  def next_solution(structure)
    solution = structure.shuffle
    duplicated?(solution) ? next_solution(structure) : save_solution(solution)
  end

  def save_solution(solution)
    @interactions[structure_key(solution)] = solution
  end

  def duplicated?(solution)
    !@interactions[structure_key(solution)].nil?
  end

  def structure_key(solution)
    solution.join
  end

  def max?
    @interactions.size >= @max_interaction
  end
end
