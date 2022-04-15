defmodule Marx.Tokenizer do
  @moduledoc false

  # Responsible for converting raw Markdown text into tokens
  @space_chars '\n\r\t\f\s'
  @punctuation ~w(! " # $ % & ' * + , - . / : ; < = > ? @ [ \ ] ^ _ ` { | } ~) ++ ~w[( )]
  @punctuation_chars @punctuation |> Enum.join("") |> String.to_charlist()

  def tokenize(string) do
    tokenize(string, [], [])
  end

  for p <- @punctuation do
    defp tokenize(<<"\\", unquote(p), rest::binary>>, buffer, acc) do
      acc = buffer_to_acc(buffer, acc)
      tokenize(rest, [], [{:escaped, unquote(p)} | acc])
    end
  end

  defp tokenize(<<c::utf8, rest::binary>>, buffer, acc) when c in @punctuation_chars do
    acc = buffer_to_acc(buffer, acc)
    tokenize(rest, [], [<<c::utf8>> | acc])
  end

  defp tokenize(<<w::utf8, rest::binary>>, buffer, acc) when w in @space_chars do
    tokenize_whitespace(rest, [<<w::utf8>>], buffer_to_acc(buffer, acc))
  end

  defp tokenize(<<c::utf8, rest::binary>>, buffer, acc) do
    tokenize(rest, [<<c::utf8>> | buffer], acc)
  end

  defp tokenize(<<>>, buffer, acc) do
    buffer_to_acc(buffer, acc) |> Enum.reverse()
  end

  defp tokenize_whitespace(<<w::utf8, rest::binary>>, buffer, acc) when w in @space_chars do
    tokenize_whitespace(rest, [<<w::utf8>> | buffer], acc)
  end

  defp tokenize_whitespace(text, buffer, acc) do
    tokenize(text, [], buffer_to_acc(buffer, acc, :ws))
  end

  defp buffer_to_acc([], acc), do: acc
  defp buffer_to_acc(buffer, acc, type \\ :text), do: [{type, to_text(buffer)} | acc]

  defp to_text(buffer) do
    buffer |> Enum.reverse() |> IO.iodata_to_binary()
  end
end
