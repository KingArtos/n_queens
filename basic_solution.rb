# BasicSolution.new(X).run
class BasicSolution
  def initialize(size = 8, max_interaction = 1000)
    @interactions = {}
    @structure = size.times.to_a
    @max_interaction = max_interaction
  end

  def run
    loop do
      solution = next_solution
      break if solution?(solution) || max?
    end
    max? ? 'Not Found' : solution
  end

  def print_solution(solution)
    puts formated_solution(solution)
  end

  def solution?(solution)
  end

  def formated_solution(solution)
    solution.map do |i|
      mat = Array.new(solution.size, '-')
      mat[i] = 'Q'
      mat.join(' ')
    end
  end

  private

  def next_solution(structure)
    solution = structure.shuffle
    duplicated?(solution) ? next_solution(structure) : save_solution(solution)
  end

  def save_solution(solution)
    @interaction[structure_key(solution)] = solution
  end

  def duplicated?(solution)
    @interaction[structure_key(solution)].present?
  end

  def structure_key(solution)
    solution.join
  end

  def max?
    @interactions.size >= @max_interaction
  end
end
