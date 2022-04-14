defmodule Marx.TokenizerTest do
  use ExUnit.Case

  import Marx.Tokenizer, only: [tokenize: 1]

  test "should not tokenize escaped punctuation" do
    assert tokenize("hello \!") == ""
  end

  test "should tokenize asterisks" do
    assert tokenize("*dude*") == ["*", "dude", "*"]
  end
end
