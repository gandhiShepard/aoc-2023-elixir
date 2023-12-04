defmodule AdventOfCode.Day02 do
  def part1(input, sum_of_valid_game_Ids \\ 0)
  def part1(<<>>, sum_of_valid_game_Ids), do: sum_of_valid_game_Ids
  def part1(input, sum_of_valid_game_Ids) do
    [game, input] = String.split(input, "\n", parts: 2)
    part1(input, sum_of_valid_game_Ids + id_if_valid(game))
  end

  defp id_if_valid(game) do
    [game, sets] = String.split(game, ":")
    sets = String.split(sets, ";")
    if(Enum.all?(sets, &valid_set?/1), do: game_id(game), else: 0)
  end

  defp valid_set?(set) do
    counts_and_numbers = String.split(set, ",")
    Enum.all?(counts_and_numbers, &count_and_number_possible?/1)
  end

  defp count_and_number_possible?(count_and_number) do
    case String.split(count_and_number, " ", trim: true) do
      [count, "red"] -> String.to_integer(count) <= 12
      [count, "green"] -> String.to_integer(count) <= 13
      [count, "blue"] -> String.to_integer(count) <= 14
    end
  end

  defp game_id("Game " <> id), do: String.to_integer(id)

  def part2(_args) do
  end
end
