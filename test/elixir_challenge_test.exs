defmodule ElixirChallengeTest do
  use ExUnit.Case
  doctest ElixirChallenge

  test "zero: math power" do
    expected = 274877906944
    actual = ElixirChallenge.zero 2, 38
    IO.puts "Challenge 0: " <> to_string(actual)
    assert actual == expected
  end

  test "one: decode string where m -> o" do
    expected = "ocr"
    actual = ElixirChallenge.one "map"
    IO.puts "Challenge 1: " <> actual
    assert actual == expected
  end

  test "two_cheat: find rare letters" do
    expected = "equality"
    actual = ElixirChallenge.two_cheat()
    assert actual == expected
  end

  test "two: find rare characters without assumptions" do
    expected = "equality"
    actual = ElixirChallenge.two()
    IO.puts "Challenge 2: " <> actual
    assert actual == expected
  end

  test "three: find guarded characters" do
    expected = "linkedlist"
    actual = ElixirChallenge.three()
    IO.puts "Challenge 3: " <> actual
    assert actual == expected
  end

  # Not a great test :)
  test "five: print the word" do
    expected = :ok
    IO.puts "Challenge 5:"
    actual = ElixirChallenge.five()
    assert actual == expected
  end

  test "six: ?" do
    
  end

end
