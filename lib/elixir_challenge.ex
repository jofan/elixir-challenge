defmodule ElixirChallenge do

  @moduledoc """
  The solutions to The Python Challenge in Elixir

  Base solution URL: http://www.pythonchallenge.com/pc/def/
  """

  @doc """
  Solution to Challenge 0

  Solve 2^38 and replace 0 in URL with result

  Elixir-lessons learned:

  - Defining functions
  - Using Elixir Enum and Stream modules
  - Anonymous functions
  - Using @doc 

  """
  #solution is 274877906944
  def zero(x, pow) do
    Enum.reduce(Enum.take(Stream.repeatedly(fn -> x end), pow), &*/2)
  end


  @doc """
  Solution to Challenge 1

  Decode string to find instructions.
  Apply same method on URL and update with result.

  Elixir-lessons learned:

  - Elixir pipe command
  - Elixir private functions
  - Pattern-matching functions
  - String binaries!

  Final solution has one downside: it only work with 1 byte characters, so no åäö

  """
  # Solution is 'ocr'
  def one do
    str = "g fmnc wms bgblr rpylqjyrc gr zw fylb. rfyrq ufyr amknsrcpq ypc dmp. bmgle gr gl zw fylb gq glcddgagclr ylb rfyr'q ufw rfgq rcvr gq qm jmle. sqgle qrpgle.kyicrpylq() gq pcamkkclbcb. lmu ynnjw ml rfc spj."
    one(str, 2)
    one("map", 2) # 'map' is the current file name in URL 
  end

  def one(str, shift) do
    str
      |> String.codepoints
      |> Enum.reduce("", fn char, acc -> 
        <<bin, _::binary>> = char
        acc <> <<bin + shift>>
      end)
  end

  # First solution :)
  # def one(str) do
  #   str |> String.codepoints |> Enum.map(&one_convert/1) |> to_string
  #   # to_string(Enum.map(String.codepoints(str), &one_convert/1))
  # end
  # defp one_convert("a"), do: "c" 
  # defp one_convert("b"), do: "d" 
  # defp one_convert("c"), do: "e" 
  # defp one_convert("d"), do: "f" 
  # defp one_convert("e"), do: "g" 
  # defp one_convert("f"), do: "h" 
  # defp one_convert("g"), do: "i" 
  # defp one_convert("h"), do: "j" 
  # defp one_convert("i"), do: "k" 
  # defp one_convert("j"), do: "l" 
  # defp one_convert("k"), do: "m" 
  # defp one_convert("l"), do: "n" 
  # defp one_convert("m"), do: "o" 
  # defp one_convert("n"), do: "p" 
  # defp one_convert("o"), do: "q" 
  # defp one_convert("p"), do: "r" 
  # defp one_convert("q"), do: "s" 
  # defp one_convert("r"), do: "t" 
  # defp one_convert("s"), do: "u" 
  # defp one_convert("t"), do: "v" 
  # defp one_convert("u"), do: "w" 
  # defp one_convert("v"), do: "x" 
  # defp one_convert("w"), do: "y" 
  # defp one_convert("x"), do: "z" 
  # defp one_convert("y"), do: "a" 
  # defp one_convert("z"), do: "b"
  # # Any non lower-letter character is simply left as is
  # defp one_convert(x), do: x


  @doc """
  Solution to Challenge 2

  Find unique characters in huge list of repeated ones.

  Elixir-lessons learned:

  - Use of pattern matching with recursion
  - Keeping "state" with immutable data
  - Using Elixir lists
  - Use of Elixir if/else macro
  - Reading files in Elixir

  """
  # Solution is 'equality'
  # Inspired by Dave Thomas: https://www.youtube.com/watch?v=ZQdLG0biiYA&ebc=ANyPxKqIjWS7Tzvo2TX6ed7Al9p3qKe5gwOiPp0MDkDOOxwMnDCiXWNHJYqwjXe4xDKJKFZSrizJ
  def two do
    {:ok, content} = File.read("lib/challenge2_data.txt")
    two(content)
  end
  def two(str) do
    str
      |> String.codepoints
      |> _compare([], [])
      |> to_string 
  end

  defp _compare([], _, unique), do: Enum.reverse unique

  defp _compare([h|tail], [], []), do: _compare(tail, [h], [h])

  defp _compare([h|tail], previous, unique) do
    if Enum.member?(previous, h) do
      _compare(tail, previous, List.delete(unique, h))
    else
      _compare(tail, [h|previous], [h|unique])
    end
  end

  # EXTRA: initial solution with Regex
  # This work assuming 'rare' characters are letters... but that's a bit of a cheat
  def two_cheat do
    {:ok, content} = File.read("lib/challenge2_data.txt")
    rare_letters = Regex.scan(~r/[a-zA-Z]+/, content)
    rare_letters |> to_string
  end


  @doc """
  Solution to Challenge 3

  Use regex to find letters in pattern (aAAAxAAAa)

  Elixir-lessons learned:

  - Use of Regex module and 'scan' function

  """
  # Solution is 'linkedlist'
  # http://www.pythonchallenge.com/pc/def/linkedlist.php
  def three do
    {:ok, content} = File.read("lib/challenge3_data.txt")
    three(content)
  end
  def three(str) do
    guarded_letters = Regex.scan(~r/[^A-Z][A-Z]{3}([a-z]{1})[A-Z]{3}[^A-Z]/, str, capture: :all_but_first)
    guarded_letters |> to_string
  end

  @doc """
  Solution to Challenge 4

  Continiously request the URL http://www.pythonchallenge.com/pc/def/linkedlist.php
  with the query '?nothing=12345' where the number is updated from the body of the fetched page.

  Monitor the body of each request and follow the instructions when they appear. No more than
  400 iterations should be necessary.

  Elixir-lessons learned:

  - Use of third-party module (HTTPoison)
  - Use of regex
  - Use of recursive iteration
  - Use of pattern matching
  - Use of conditionals (case and cond)
  - Use of string interpolations

  TODO: Increase timeout of HTTPoison call: http://hexdocs.pm/httpoison/HTTPoison.html#request!/5

  """
  # First important URL: First part: http://www.pythonchallenge.com/pc/def/linkedlist.php?nothing=16044
  # Will tell you to: Yes. Divide by two and keep going.
  # Solution is 'peak.html'
  def four do
    HTTPoison.start
    four("12345", 0)
  end
  def four(query, iteration) do
    base_url = "http://www.pythonchallenge.com/pc/def/linkedlist.php?nothing="
    case HTTPoison.get(base_url <> query) do
      {:ok, %HTTPoison.Response{status_code: 200, headers: _, body: body}} ->
        next = Regex.run(~r/and the next nothing is ([0-9]+)/, body, capture: :all_but_first)
        IO.write "."
        cond do
          body == "Yes. Divide by two and keep going." ->
            IO.puts ""
            IO.puts body
            four(to_string(String.to_integer(query) / 2), iteration + 1)
          body == "peak.html" ->
            IO.puts ""
            IO.puts "Done in #{to_string(iteration)} iterations!"
            IO.puts "The solution is: #{body}"
          iteration > 400 ->
            IO.puts "Too many iterations!"
          true ->
            four(to_string(next), iteration + 1)
        end
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end


  @doc """
  Solution to Challenge 5

  Need to use Python's pickle module for this (in python repl):
  
  import pickle
  file = open("lib/banner.p", "r")
  pickle.load(file)

  Elixir-lessons learned:

  - Use of Enum.reduce with accumulation
  - Use of regex to turn string to appropriate list
  - Use of IO.write and puts

  TODO: output result to file

  """
  # Solution is 'channel'
  def five do
    {:ok, content} = File.read("lib/challenge5_data.txt")
    five(content)
  end

  def five(content) do
    data = Regex.scan(~r/'([#\s])',\s([0-9]+)/, content, capture: :all_but_first)
    Enum.reduce data, 0, fn item, acc ->
      [char|int] = item
      repeat = int |> List.first |> String.to_integer
      count = repeat + acc
      _printChars char, repeat
      if rem(count, 95) == 0 do
        IO.puts ""
      end
      count
    end
    IO.write ""
  end

  defp _printChars(char, repeat) do
    # repeat = int |> List.first |> String.to_integer
    Enum.each 1..repeat, fn _ -> 
      IO.write(char)
    end
  end

  @doc """
  Solution to Challenge 6

  Extract channel.zip file and find the next nothings.
  Like Challenge 4 but with hints in .txt files instead.

  Readme.txt mentions to start with lib/channel/90052.txt

  Hint after traversing the file is: "Collect the comments"
  You're supposed to read file comments when looping through.
  Don't know how to read file comments using Elixir/Erlang though

  Solution is "oxygen"

  """
  def six do
    six "90052", 0
  end
  def six(file, acc) do
    # content = File.read!("lib/channel/" <> file <> ".txt")
    # next = Regex.run(~r/and the next nothing is ([0-9]+)/, content, capture: :all_but_first)
    #   IO.puts to_string(content)
    #   six next
    filename = "lib/channel/" <> file <> ".txt"
    case File.read(filename) do
      {:ok, body} ->
        next = Regex.run(~r/Next nothing is ([0-9]+)/, body, capture: :all_but_first)
        if next do
          IO.puts to_string(body)
          six to_string(next), String.to_integer(file) + acc
        else
          IO.puts to_string(body)
          IO.puts String.to_integer(file) + acc
        end
    end
  end

end
