defmodule Marx.Tokenizer do
  @moduledoc false

  # Responsible for converting raw Markdown text into tokens

  @punctuation ~w(! " # $ % & ' * + , - . / : ; < = > ? @ [ \ ] ^ _ ` { | } ~) ++ ~w[( )]
  @punctuation_charlist @punctuation |> Enum.join("") |> String.to_charlist()

  def tokenize(string) do
    tokenize(string, [], [])
  end

  for p <- @punctuation do
    defp tokenize(<<"\\", unquote(p), rest::binary>>, buffer, acc) do
      acc = buffer_to_acc(buffer, acc)
      tokenize(rest, [], [{:escaped, unquote(p)} | acc])
    end
  end

  defp tokenize(<<c::utf8, rest::binary>>, buffer, acc) when c in @punctuation_charlist do
    acc = buffer_to_acc(buffer, acc)
    tokenize(rest, [], [<<c::utf8>> | acc])
  end

  defp tokenize(<<c::utf8, rest::binary>>, buffer, acc) do
    tokenize(rest, [<<c::utf8>> | buffer], acc)
  end

  defp tokenize(<<>>, buffer, acc) do
    buffer_to_acc(buffer, acc) |> Enum.reverse()
  end

  defp buffer_to_acc([], acc), do: acc
  defp buffer_to_acc(buffer, acc), do: [{:text, to_text(buffer)} | acc]

  defp to_text(buffer) do
    buffer |> Enum.reverse() |> IO.iodata_to_binary()
  end
end
