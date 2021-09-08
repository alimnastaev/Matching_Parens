defmodule ParensBracketsBraces do
  @openers ["{", "[", "("]
  @closers ["}", "]", ")"]
  @all @openers ++ @closers

  def matching?(input) when is_binary(input), do: run_check("", input)
  def matching?(input), do: "#{inspect(input)} is not a valid string."
  def matching?(), do: "input should be a valid string"

  ### --- BASE CASES --- ###
  # matching pairs
  defp run_check("" = _stack, "" = _input), do: true
  # no matches
  defp run_check(_, "" = _input), do: false

  ### matches on openers only and putting it to the stack ###
  defp run_check(stack, <<opener::binary-size(1)>> <> input_tail)
       when opener in @openers,
       do: run_check(opener <> stack, input_tail)

  ### making a recursive step wider ###
  defp run_check(stack, <<elem::binary-size(1)>> <> " " <> input_tail)
       when elem not in @all,
       do: run_check(stack, input_tail)

  defp run_check(stack, " " <> <<elem::binary-size(1)>> <> input_tail)
       when elem not in @all,
       do: run_check(stack, input_tail)

  ### only closers ###
  defp run_check("" = _stack, <<closer::binary-size(1)>> <> _input_tail)
       when closer in @closers,
       do: false

  ### comparing top item in the stack with closer ###
  defp run_check("[" <> stack_tail, "]" <> input_tail),
    do: run_check(stack_tail, input_tail)

  defp run_check("(" <> stack_tail, ")" <> input_tail),
    do: run_check(stack_tail, input_tail)

  defp run_check("{" <> stack_tail, "}" <> input_tail),
    do: run_check(stack_tail, input_tail)

  ### if not openers or/and closers ###
  defp run_check(stack, <<_::binary-size(1)>> <> input_tail), do: run_check(stack, input_tail)
end

case System.argv() do
  ["--test"] ->
    ExUnit.start()

    defmodule ParensBracketsBracesTest do
      use ExUnit.Case

      test "Parens.is_matching?/1" do
        assert ParensBracketsBraces.matching?("1 * 2 (3 + [4 / 5])") == true
        assert ParensBracketsBraces.matching?("1 * 2 (3 + [4 / 5]") == false

        assert ParensBracketsBraces.matching?("(a + [ b - c ] )") == true
        assert ParensBracketsBraces.matching?("(a + [ b - c ) ]") == false
        assert ParensBracketsBraces.matching?("(a + [ b - c ] ) ]") == false

        assert ParensBracketsBraces.matching?("[4") == false

        assert ParensBracketsBraces.matching?("5[(") == false
        assert ParensBracketsBraces.matching?("5]") == false
        assert ParensBracketsBraces.matching?("3 ]4) 9} ") == false
        assert ParensBracketsBraces.matching?("[{(") == false
        assert ParensBracketsBraces.matching?("}])") == false
        assert ParensBracketsBraces.matching?("[}[{(") == false
        assert ParensBracketsBraces.matching?("[}{}") == false

        assert ParensBracketsBraces.matching?(
                 "( ( ( . ( (   (  ( ( ( (  [   [ { .      []}]]))))()([[[]]])))))))   -     -     /    {({({({{{{({()})}{({})}}}})})})}[]"
               ) == true

        assert ParensBracketsBraces.matching?([3]) == "[3] is not a valid string."
        assert ParensBracketsBraces.matching?(3) == "3 is not a valid string."
        assert ParensBracketsBraces.matching?() == "input should be a valid string"
      end
    end

  _ ->
    IO.puts(:stderr, "\nplease specify --test flag")
end
