defmodule Marx.TokenizerTest do
  use ExUnit.Case

  import Marx.Tokenizer, only: [tokenize: 1]

  test "should tokenize basic structures" do
    assert tokenize("A paragraph __with__ some *text*") ==
             [
               {:text, "A paragraph "},
               "_",
               "_",
               {:text, "with"},
               "_",
               "_",
               {:text, " some "},
               "*",
               {:text, "text"},
               "*"
             ]
  end

  test "should escape escaped punctuation" do
    assert tokenize("hello \\!") == [{:text, "hello "}, {:escaped, "\!"}]
    assert tokenize("hello \!") == [{:text, "hello "}, "!"]
    assert tokenize("hello !") == [{:text, "hello "}, "!"]
  end

  test "should tokenize asterisks" do
    assert tokenize("*dude*") == ["*", {:text, "dude"}, "*"]
  end
end
