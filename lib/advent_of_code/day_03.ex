defmodule AdventOfCode.Day03 do
  @moduledoc """
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

  @special_chars ~w[- # = * + @ $ & / %]
  @numbers ~w[0 1 2 3 4 5 6 7 8 9]

  def part1(input) do
    input
    |> process_char()
    |> find_adjacent_numbers()
  end

  defp process_char(
         input,
         current_position \\ {0, 0},
         temp \\ {0, []},
         number_map \\ %{},
         special_chars \\ []
       )

  defp process_char(
         <<current_number::binary-size(1), rest::binary>>,
         current_position,
         {0, []},
         number_map,
         special_chars
       )
       when current_number in @numbers,
       do:
         process_char(
           rest,
           increment_position(current_position),
           {String.to_integer(current_number), [current_position]},
           number_map,
           special_chars
         )

  defp process_char(
         <<current_number::binary-size(1), rest::binary>>,
         current_position,
         {number, coords},
         number_map,
         special_chars
       )
       when current_number in @numbers,
       do:
         process_char(
           rest,
           increment_position(current_position),
           {10 * number + String.to_integer(current_number), [current_position | coords]},
           number_map,
           special_chars
         )

  defp process_char(<<".", rest::binary>>, current_position, temp, number_map, special_chars),
    do:
      process_char(
        rest,
        increment_position(current_position),
        {0, []},
        update_number_map(number_map, temp),
        special_chars
      )

  defp process_char(<<"\n", rest::binary>>, current_position, temp, number_map, special_chars),
    do:
      process_char(
        rest,
        increment_position(current_position, :return),
        {0, []},
        update_number_map(number_map, temp),
        special_chars
      )

  defp process_char(
         <<spec_char::binary-size(1), rest::binary>>,
         current_position,
         temp,
         number_map,
         special_chars
       )
       when spec_char in @special_chars,
       do:
         process_char(
           rest,
           increment_position(current_position),
           {0, []},
           update_number_map(number_map, temp),
           [{spec_char, current_position} | special_chars]
         )

  defp process_char(<<>>, _current_position, _temp, number_map, special_chars),
    do: {number_map, special_chars}

  defp update_number_map(map, data),
    do: Enum.into(elem(data, 1), map, fn y -> {y, elem(data, 0)} end)

  defp increment_position({x, y}), do: {x + 1, y}
  defp increment_position({_x, y}, :return), do: {0, y + 1}

  defp find_adjacent_numbers({map, list}) do
    Enum.reduce(list, 0, fn
     {_spec_char, coord}, acc ->
        look_up(coord, map) + left(coord, map) + right(coord, map) + look_down(coord, map) + acc
    end)
  end

  # we do this to prevent consecutive matches
  defp look_up(coord, map) do
    case {left_up(coord, map), up(coord, map), right_up(coord, map)} do
      {x, x, x} -> x
      {x, y, x} -> x + y + x
      {x, x, y} -> x + y
      {y, x, x} -> y + x
      {x, y, z} -> x + y + z
    end
  end

  defp look_down(coord, map) do
    case {left_down(coord, map), down(coord, map), right_down(coord, map)} do
      {x, x, x} -> x
      {x, y, x} -> x + y + x
      {x, x, y} -> x + y
      {y, x, x} -> y + x
      {x, y, z} -> x + y + z
    end
  end

  defp find_gears({map, list}) do
    Enum.reduce(list, 0, fn
      {"*", coord}, acc ->
        look_around(coord, map) + acc
      {_, _coords}, acc -> acc
    end)
  end

  defp up_check(coord, map) do
    case {left_up(coord, map), up(coord, map), right_up(coord, map)} do
      {0, 0, x} -> [x]
      {0, x, 0} -> [x]
      {x, x, x} -> [x]
      {x, 0, x} -> [x, x]
      {x, x, y} -> [x, y]
      {x, 0, y} -> [x, y]
      {y, x, x} -> [x, y]
      _ -> []
    end
  end

  defp down_check(coord, map) do
    case {left_down(coord, map), down(coord, map), right_down(coord, map)} do
      {0, 0, x} -> [x]
      {0, x, 0} -> [x]
      {x, x, x} -> [x]
      {x, 0, x} -> [x, x]
      {x, x, y} -> [x, y]
      {x, 0, y} -> [x, y]
      {y, x, x} -> [x, y]
      _ -> []
    end
  end


  defp look_around(coord, map) do
    [
      left(coord, map),
      right(coord, map),
      up_check(coord, map),
      down_check(coord, map)
    ]
    |> List.flatten()
    |> Enum.reject(& &1 == 0)
    |> then(fn
      [x, x] -> x * x
      [x, y] -> x * y
      _ -> 0
    end)
    # |> dbg()
  end


  defp left_up({x, y}, map), do: Map.get(map, {x - 1, y - 1}, 0)
  defp up({x, y}, map), do: Map.get(map, {x, y - 1}, 0)
  defp right_up({x, y}, map), do: Map.get(map, {x + 1, y - 1}, 0)

  defp left({x, y}, map), do: Map.get(map, {x - 1, y}, 0)
  defp right({x, y}, map), do: Map.get(map, {x + 1, y}, 0)

  defp left_down({x, y}, map), do: Map.get(map, {x - 1, y + 1}, 0)
  defp down({x, y}, map), do: Map.get(map, {x, y + 1}, 0)
  defp right_down({x, y}, map), do: Map.get(map, {x + 1, y + 1}, 0)

  def part2(input) do
    input
    |> process_char()
    |> find_gears()
  end
end
