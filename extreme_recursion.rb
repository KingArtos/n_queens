require './shuffle_solutions'
class ExtremeRecursion < ShuffleSolutions
  def check_possible_evolutions
    @solutions.select do |solution|
      solution? evolution(solution, solution.count)
    end
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

  def my_solution(solution, ci)
    ci == solution.count / 2 ? mirror(solution) : solution
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

  def check(input)
    input.instance_of?(Array) ? mirror(input) : input
  end
end
