defmodule AdventOfCode.Day01 do
  @newline 10

  @spec part1(String.t()) :: non_neg_integer()
  def part1(input, first \\ nil, last \\ nil, sum \\ 0)

  def part1(<<d, input::binary>>, nil, nil, sum) when d in ?0..?9,
    do: part1(input, d - ?0, d - ?0, sum)

  def part1(<<d, input::binary>>, first, _last, sum) when d in ?0..?9,
    do: part1(input, first, d - ?0, sum)

  def part1(<<@newline, input::binary>>, first, last, sum),
    do: part1(input, nil, nil, sum + 10 * first + last)

  def part1(<<_, input::binary>>, first, last, sum), do: part1(input, first, last, sum)
  def part1(<<>>, _, _, sum), do: sum

  @spec part2(String.t()) :: non_neg_integer()
  def part2(input, first \\ nil, last \\ nil, sum \\ 0)

  Enum.each(
    Enum.zip(0..9, [
      "zero",
      "one",
      "two",
      "three",
      "four",
      "five",
      "six",
      "seven",
      "eight",
      "nine"
    ]),
    fn {n, numberstring} ->
      d = n + ?0

      def part2(<<unquote(d), input::binary>>, nil, nil, sum),
        do: part2(input, unquote(n), unquote(n), sum)

      def part2(<<unquote(d), input::binary>>, first, _last, sum),
        do: part2(input, first, unquote(n), sum)

      def part2(unquote(numberstring) <> <<input::binary>>, nil, nil, sum),
        do: part2(input, unquote(n), unquote(n), sum)

      def part2(unquote(numberstring) <> <<input::binary>>, first, _last, sum),
        do: part2(input, first, unquote(n), sum)
    end
  )

  def part2(<<@newline, input::binary>>, nil, _, sum), do: raise("Unexpected row without numbers")

  def part2(<<@newline, input::binary>>, first, last, sum),
    do: part2(input, nil, nil, sum + dbg(10 * first + last))

  def part2(<<_, input::binary>>, first, last, sum), do: part2(input, first, last, sum)
  def part2(<<>>, _, _, sum), do: sum
end
