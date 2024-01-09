defmodule AdventOfCode.Day04 do
  @moduledoc """
  Part one seems to be fast.
  Part 2 is REALLY slow!
  I think that I chose the wrong direction passing the input into the acc slot.

  Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
  Card 203: 59 31 79 81  4 21 24 54 48 62 | 37 90 25 51 70 77 18 17 97 52 40 75 43  3 91 50 87 67 42 15 14 63  6 13  5
  """

  @spec part1(String.t) :: non_neg_integer()
  def part1(input), do: ignore_until_semicolon(input)
  # ignore all characters in line until a semicolon is reached
  defp ignore_until_semicolon(input, total_points \\ {0, 0})
  defp ignore_until_semicolon("", {_, game_points}) do
  # IO.inspect(game_points, label: "game points")
  game_points
  end

  defp ignore_until_semicolon(<<":  ", rest::binary>>, total_points), do: get_winning_numbers(rest, total_points)
  defp ignore_until_semicolon(<<": ", rest::binary>>, total_points), do: get_winning_numbers(rest, total_points)
  defp ignore_until_semicolon(<<_, rest::binary>>, total_points), do: ignore_until_semicolon(rest, total_points)

  # get winning numbers
  defp get_winning_numbers(input, total_points, build_number \\ nil, winning_numbers \\ [], our_numbers \\ nil)

  defp get_winning_numbers(<<"| ", rest::binary>>, total_points, nil, winning_numbers, our_numbers) do
    # IO.inspect(winning_numbers, label: "winning_numbers")
    get_our_numbers(rest, total_points, winning_numbers, our_numbers)
    end


  defp get_winning_numbers(<<"| ", rest::binary>>, total_points, build_number, winning_numbers, our_numbers) do
    # IO.inspect(winning_numbers, label: "winning_numbers")
    get_our_numbers(rest, total_points, [build_number | winning_numbers], our_numbers)
    end

  defp get_winning_numbers(<<"  ", rest::binary>>, total_points, build_number, winning_numbers, our_numbers) do

    # IO.inspect(build_number, label: "build number")
    get_winning_numbers(rest, total_points, nil, [build_number | winning_numbers], our_numbers)
    end

  defp get_winning_numbers(<<" ", rest::binary>>, total_points, build_number, winning_numbers, our_numbers) do

    # IO.inspect(build_number, label: "build number")
    get_winning_numbers(rest, total_points, nil, [build_number | winning_numbers], our_numbers)
    end

  defp get_winning_numbers(<<c, rest::binary>>, total_points, nil, winning_numbers, our_numbers),
    do: get_winning_numbers(rest, total_points, c - ?0, winning_numbers, our_numbers)

  defp get_winning_numbers(<<c, rest::binary>>, total_points, build_number, winning_numbers, our_numbers) do
    # IO.inspect(build_number, label: "build number")
    get_winning_numbers(rest, total_points, build_number * 10 + (c - ?0), winning_numbers,  our_numbers)
    end

  # get our numbers and check if they are in the winning number list. If so, then add a point to total_points for each match
  defp get_our_numbers(<<"\n", rest::binary>>, {card_points, game_points}, winning_numbers, our_numbers),
    do: ignore_until_semicolon(rest, calculate_points(check_points(winning_numbers, our_numbers) + card_points, game_points))

  defp get_our_numbers(<<"  ", rest::binary>>, {card_points, game_points}, winning_numbers, our_numbers)
    do
    # IO.inspect({winning_numbers, our_numbers}, label: "our numbers")
    get_our_numbers(rest, {check_points(winning_numbers, our_numbers) + card_points, game_points}, winning_numbers, nil)
    end

  defp get_our_numbers(<<" ", rest::binary>>, {card_points, game_points}, winning_numbers, our_numbers)
    do
    # IO.inspect({winning_numbers, our_numbers}, label: "our numbers")
    get_our_numbers(rest, {check_points(winning_numbers, our_numbers) + card_points, game_points}, winning_numbers, nil)
    end

  defp get_our_numbers(<<c, rest::binary>>, total_points, winning_numbers, nil),
    do: get_our_numbers(rest, total_points, winning_numbers, c - ?0)

  defp get_our_numbers(<<c, rest::binary>>, total_points, winning_numbers, our_numbers) do
    # IO.inspect(our_numbers, label: "our_numbers")
    get_our_numbers(rest, total_points, winning_numbers, our_numbers * 10 + (c - ?0))
    end

  defp check_points(list, number) do
    case Enum.member? list, number do
      true -> 1
      false -> 0
    end
  end

  @spec calculate_points(non_neg_integer, non_neg_integer) :: {0, non_neg_integer}
  defp calculate_points(card_points, game_points), do: do_calculate_points(card_points, game_points)

  defp do_calculate_points(card_points, game_points, acc \\ 0)
  defp do_calculate_points(0, game_points, acc), do: {0, game_points + acc}
  defp do_calculate_points(card_points, game_points, 0), do: do_calculate_points(card_points - 1, game_points, 1)
  defp do_calculate_points(card_points, game_points, acc), do: do_calculate_points(card_points - 1, game_points, acc * 2)

  @spec part2(String.t) :: integer
  def part2(input), do: total_cards_won(input, :none, 0)

  @spec total_cards_won(String.t, atom | integer, integer) :: integer
  def total_cards_won("", :none, acc), do: acc
  def total_cards_won(_rest, 0, acc), do: acc + 1

  def total_cards_won(input, :none, acc) do
    {rest, repeat} =
      input
      |> list_winning_numbers(:ignore, 0, [])
      |> count_our_winning_matches(0 , 0)

    total_cards_won(rest, :none, total_cards_won(rest, repeat, acc))
  end

  def total_cards_won(input, limit, acc) do
    {rest, repeat} =
      input
      |> list_winning_numbers(:ignore, 0, [])
      |> count_our_winning_matches(0, 0)

    total_cards_won(rest, limit - 1, total_cards_won(rest, repeat, acc))
  end

# ignore until these pattern are found
  @spec list_winning_numbers(String.t, atom, integer, [integer]) :: {String.t, [integer]}
  def list_winning_numbers(<<":  ", rest::binary>>, :take, tmp, winning_numbers),
    do: list_winning_numbers(rest, :take, tmp, winning_numbers)
  def list_winning_numbers(<<": ", rest::binary>>, :ignore, tmp, winning_numbers),
    do: list_winning_numbers(rest, :take, tmp, winning_numbers)

# append tmp to winning_numbers
  def list_winning_numbers(<<" ", rest::binary>>, :take, tmp, winning_numbers),
    do: list_winning_numbers(rest, :take, 0, [tmp | winning_numbers])

# when tmp is 0 tmp is a single digit
  def list_winning_numbers(<<n, rest::binary>>, :take, 0, winning_numbers) when n in ?0..?9,
    do: list_winning_numbers(rest, :take, n - ?0, winning_numbers)

# otherwise tmp is two digits long
  def list_winning_numbers(<<n, rest::binary>>, :take, tmp, winning_numbers) when n in ?0..?9,
    do: list_winning_numbers(rest, :take, tmp * 10 + n - ?0, winning_numbers)

# Return clauses
# hand off to count_our_winning_matches
  def list_winning_numbers(<<"|  ", rest::binary>>, :take, _tmp, winning_numbers), do: {rest, winning_numbers}
  def list_winning_numbers(<<"| ", rest::binary>>, :take, _tmp, winning_numbers), do: {rest, winning_numbers}

# otherwise, ignore anything else and keep chunking
  def list_winning_numbers(<<_, rest::binary>>, :ignore, tmp, winning_numbers),
    do: list_winning_numbers(rest, :ignore, tmp, winning_numbers)

# Return clause - end of line reached
  @spec count_our_winning_matches({String.t, [integer]}, integer, integer) :: {String.t, integer}
  def count_our_winning_matches({<<"\n", rest::binary>>, winning_numbers}, tmp, count),
    do: {rest, do_count(tmp, winning_numbers, count)}

# With a space OR double space, check for tmp in winning_numbers
  def count_our_winning_matches({<<"  ", rest::binary>>, winning_numbers}, tmp, count),
    do: count_our_winning_matches({rest, winning_numbers}, 0, do_count(tmp, winning_numbers, count))

  def count_our_winning_matches({<<" ", rest::binary>>, winning_numbers}, tmp, count),
    do: count_our_winning_matches({rest, winning_numbers}, 0, do_count(tmp, winning_numbers, count))
# When n is 0..9
  def count_our_winning_matches({<<n, rest::binary>>, winning_numbers}, 0, count) when n in ?0..?9,
    do: count_our_winning_matches({rest, winning_numbers}, n - ?0, count)

# When n is 0..9
  def count_our_winning_matches({<<n, rest::binary>>, winning_numbers}, tmp, count) when n in ?0..?9,
    do: count_our_winning_matches({rest, winning_numbers}, tmp * 10 + n - ?0, count)


  def do_count(_tmp, [], count), do: count
  def do_count(tmp, [tmp | _t], count), do: count + 1
  def do_count(tmp, [_h | t], count), do: do_count(tmp, t, count)
end
