defmodule Marx.Block.Tokenizer do
  # TODO remove
  def tokenize(string) do
    String.split(string, ["\r\n", "\n", "\r"])
  end
end
