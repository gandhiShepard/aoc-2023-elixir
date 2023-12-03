defmodule AdventOfCode.Day02 do
  @key_1 %{
    "red" => 12,
    "green" => 13,
    "blue" => 14
  }

  @spec part1(String.t) :: non_neg_integer
  def part1(input) do
    input
    |> String.split("\n", trim: true)
    # ["Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green", ...]
    |> Enum.reduce(0, fn x, acc ->
			["Game " <> id, rounds_as_string] = String.split(x, ": ", trim: true)

			round_as_tuples =
        rounds_as_string
        |> String.split("; ")
        # ["2 blue, 4 red", "1 red, 2 green"]
        |> Enum.map(fn x -> String.split(x, ", ") end)
        # [ ["2 blue", "4 red"], ["1 red", "2 green"] ]
        |> Enum.map(fn x -> Enum.map(x, fn y -> Integer.parse(y) end) end)
        # [ [{3, "blue"}, {4, "red"}], [{}], ...  ]
        |>  Enum.reduce([], fn
          x, acc ->
            result = Enum.reduce(x, @key_1, fn
              {count, " red"}, acc -> %{acc | "red" => acc["red"] - count}
              {count, " green"}, acc -> %{acc | "green" => acc["green"] - count}
              {count, " blue"}, acc -> %{acc | "blue" => acc["blue"] - count}
            end)

            case Enum.any?(result, fn {_k, v} -> v < 0 end) do
              true -> [false | acc]
              false -> [true | acc]
            end
        end)

      case Enum.all?(round_as_tuples, fn x -> x == true end) do
        true -> acc + String.to_integer(id)
        false -> acc
      end

    end)
  end

  @spec part2(String.t) :: non_neg_integer
  def part2(input) do
    input
    |> String.split("\n", trim: true)
    # ["Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green", ...]
    |> Enum.map(fn x ->
			[_game_id, rounds] = String.split(x, ": ", trim: true)

      rounds
      |> String.split("; ")
      # ["2 blue, 4 red", "1 red, 2 green"]
      |> Enum.map(fn x -> String.split(x, ", ") end)
      # [ ["2 blue", "4 red"], ["1 red", "2 green"] ]
      |> Enum.map(fn x -> Enum.map(x, fn y -> Integer.parse(y) end) end)
      # # [ [{3, "blue"}, {4, "red"}], [{}], ...  ]
      |> Enum.reduce(%{}, fn
        x, acc ->
          Enum.reduce(x, acc, fn
            {count, " red"}, acc -> Map.update(acc, " red", [count], & [count | &1 ])
            {count, " green"}, acc -> Map.update(acc, " green", [count], & [count | &1 ])
            {count, " blue"}, acc -> Map.update(acc, " blue", [count], & [count | &1 ])
          end)

      end)
      |> Enum.map(fn {_k, v} ->Enum.max(v) end)
    end)
    |> Enum.reduce(0, fn x, acc -> acc + Enum.product(x) end)
    # |> dbg()
  end
end
