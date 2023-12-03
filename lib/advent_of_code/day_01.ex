defmodule AdventOfCode.Day01 do

  @newline 10

  @spec part1(String.t) :: non_neg_integer()
  def part1(input, first \\ nil, last \\ nil, sum \\ 0)
  def part1(<<d, input::binary>>, nil, nil, sum) when d in ?0..?9, do: part1(input, d-?0, d-?0, sum)
  def part1(<<d, input::binary>>, first, _last, sum) when d in ?0..?9, do: part1(input, first, d-?0, sum)
  def part1(<<@newline, input::binary>>, first, last, sum), do: part1(input, nil, nil, sum + 10*first + last)
  def part1(<<_, input::binary>>, first, last, sum), do: part1(input, first, last, sum)
  def part1(<<>>, _, _, sum), do: sum

  @spec part2(String.t) :: non_neg_integer()
  def part2(input) do
  end

end
