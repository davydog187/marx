defmodule Marx.Block.TokenizerTest do
  use ExUnit.Case

  import Marx.Block.Tokenizer, only: [tokenize: 1]

  test "should split into lines" do
    assert tokenize("one\ntwo\rthree\r\nfour") == [
             "one",
             :newline,
             "two",
             :newline,
             "three",
             :newline,
             "four"
           ]
  end
end
