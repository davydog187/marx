defmodule Marx.Tokenizer do
  @moduledoc false

  # Responsible for converting raw Markdown text into tokens

  @punctuation ~w(! " # $ % & ' * + , - . / : ; < = > ? @ [ \ ] ^ _ ` { | } ~) ++ ~w[( )]
  @punctuation_charlist @punctuation |> Enum.join("") |> String.to_charlist()

  def tokenize(string) do
    tokenize(string, [], [])
  end

  for p <- @punctuation do
    defp tokenize(<<"\\", unquote(p), rest::binary>>, acc) do
      tokenize(rest, [{:escaped, unquote(p)} | acc])
    end
  end

  defp tokenize(<<c::utf8, rest::binary>>, buffer, acc) when c in @punctuation_charlist do
    text = to_text(buffer)
    tokenize(rest, [], [<<c::utf8>>, text | acc])
  end

  defp tokenize(<<c::utf8, rest::binary>>, buffer, acc) do
    tokenize(rest, [<<c::utf8>> | buffer], acc)
  end

  defp tokenize(<<>>, buffer, acc) do
    buffer |> to_text() |> prepend(acc) |> Enum.reverse()
  end

  defp prepend("", acc), do: acc
  defp prepend(token, acc), do: [token | acc]

  defp to_text(buffer) do
    buffer |> Enum.reverse() |> IO.iodata_to_binary()
  end
end
