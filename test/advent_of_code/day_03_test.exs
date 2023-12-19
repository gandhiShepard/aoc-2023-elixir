defmodule AdventOfCode.Day03Test do
  use ExUnit.Case

  import AdventOfCode.Day03
  # import Ben
  #
  # test "Bens statemachine can create a list of numbers from a list of characters" do
  #   input = [?4, ?6, ?7, ?., ?. , ?1, ?1, ?4, ?., ?.]
  #
  #   result = Enum.reduce(input, Ben.new(), fn char, state -> Ben.process_char(state, char) end)
  #
  #   assert Ben.numbers(result) == [467, 114]
  #
  # end

  # @tag :skip
  test "part1" do
    input = """
    467..114..
    ...*......
    ..35..633.
    ......#...
    617*......
    .....+.58.
    ..592.....
    ......755.
    ...$.*....
    .664.598..
    """

    result = part1(input)

    assert result == 4361
  end

  # @tag :skip
  test "part2" do
        input = """
    467..114..
    ...*......
    ..35..633.
    ......#...
    617*......
    .....+.58.
    ..592.....
    ......755.
    ...$.*....
    .664.598..
    """

    result = part2(input)

    assert result == 467835
  end
end
