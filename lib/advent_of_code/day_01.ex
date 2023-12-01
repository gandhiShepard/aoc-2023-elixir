defmodule AdventOfCode.Day01 do
  @string_to_digit %{
    "one" => 1,
    "two" => 2,
    "three" => 3,
    "four" => 4,
    "five" => 5,
    "six" => 6,
    "seven" => 7,
    "eight" => 8,
    "nine" => 9
  }
  @spec part1(String.t) :: non_neg_integer()
  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn x -> Regex.replace(~r/[a-zA-Z]/, x, "") end)
    |> Enum.map(fn x -> "#{String.first(x)}#{String.last(x)}" end)
    |> Enum.reduce(0, fn x, acc -> String.to_integer(x) + acc end)
  end

  @spec part2(String.t) :: non_neg_integer()
  def part2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn x -> Regex.scan(~r/(?=(\d|one|two|three|four|five|six|seven|eight|nine))/, x) end)
    |> Enum.map(fn x -> "#{word_to_digit(List.first(x))}#{word_to_digit(List.last(x))}" end)
    |> Enum.reduce(0, fn x, acc -> String.to_integer(x) + acc end)
  end

  Enum.each(@string_to_digit, fn {k, v} ->
    defp word_to_digit([_, unquote(k)]), do: unquote(v)
  end)
  defp word_to_digit([_, int]), do: int
end

