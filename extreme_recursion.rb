require './shuffle_solution'
class ExtremeRecursion < ShuffleSolution

  def initialize(size = 8, threads = 1)
    @evolutions = []
    @history = []
    super(size, threads)
  end

  def print_evolutions
    prints(@evolutions)
  end

  def statistic
    super
    unless @history.empty?
      history = @history.last
      Statistic.calc(history.first, history.last, 'solutions from shuffle', 'evolutions from solutions')
    end
  end

  def check_possible_evolutions(solutions = @solutions)
    @evolutions = solutions.select do |solution|
      solution? evolution(solution, solution.length)
    end
    @history << [solutions.length, @evolutions.length]
    @evolutions
  end

  def evolution(solution, size)
    result = []
    solution.each do |ci|
      cs = my_solution(solution, ci)
      cs.each do |e|
        result << (size * ci + e)
      end
    end
    result
  end

  def mirror(input = [])
    max_length = (input.length - 1)
    output = []
    (input.length/2.0).round.times do |i|
      output[i] = check(input[max_length - i])
      output[max_length - i] = check(input[i]) if (max_length - i != i)
    end
    output
  end

  private

  def my_solution(solution, ci)
    ci == solution.count / 2 ? mirror(solution) : solution
  end

  def check(input)
    input.instance_of?(Array) ? mirror(input) : input
  end
end
