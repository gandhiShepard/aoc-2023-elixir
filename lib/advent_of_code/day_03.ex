  defmodule AdventOfCode.Day03 do
    def part1(input, state \\ {_coord = {0,0}, _numbers = [:no_number], _symbols = []})
    def part1(<<c, input::binary>>, state), do: part1(input, process_char(state, c))
    def part1(<<>>, _state = {_, [:no_number | numbers], symbols} ) do
      Enum.reduce(numbers, 0, fn {{_r, _c}, _l, value} = number, sum ->
        if(Enum.any?(symbols, &adjacent_to_number?(&1, number)), do: sum + value, else: sum)
      end)
    end

    defp adjacent_to_number?({r_s, c_s} = _symbol, {{r_n, c_n}, l_n, _value} =_number) do
      r_s >= r_n - 1 && r_s <= r_n + 1
      && c_s >= c_n - 1 &&  c_s <= c_n + l_n
    end

    defp process_char(state, ?.), do: state |> end_number() |> next_col()
    defp process_char(state, ?\n), do: state |> end_number() |> next_row()
    defp process_char(state, d) when d in ?0..?9, do: state |> process_digit(d - ?0) |> next_col()
    defp process_char(state, _symbol), do: state |> end_number() |> process_symbol() |> next_col()

    defp end_number({_, [:no_number | _], _} = state), do: state
    defp end_number({coord, numbers, symbols}), do: {coord, [:no_number | numbers], symbols}

    defp process_digit({coord, [:no_number | numbers], symbols}, d), do: {coord, [{coord, 1, d} | numbers], symbols}
    defp process_digit({coord, [{c_n, l_n, v} | numbers], symbols}, d), do: {coord, [{c_n, l_n + 1, 10 * v + d}  | numbers], symbols}

    defp process_symbol({coord, numbers, symbols}), do: {coord, numbers, [coord | symbols]}

    defp next_col({{r, c}, numbers, symbols}), do: {{r, c+1}, numbers, symbols}
    defp next_row({{r, _c}, numbers, symbols}), do: {{r+1, 0}, numbers, symbols}

  def part2(_args) do
  end
end
