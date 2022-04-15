defmodule Marx.TokenizerTest do
  use ExUnit.Case

  import Marx.Tokenizer, only: [tokenize: 1]

  test "should tokenize basic structures" do
    assert tokenize("A paragraph __with__ some *text*") == [
             {:text, "A"},
             {:ws, " "},
             {:text, "paragraph"},
             {:ws, " "},
             "_",
             "_",
             {:text, "with"},
             "_",
             "_",
             {:ws, " "},
             {:text, "some"},
             {:ws, " "},
             "*",
             {:text, "text"},
             "*"
           ]
  end

  test "should escape escaped punctuation" do
    assert tokenize("hello \\!") == [{:text, "hello"}, {:ws, " "}, {:escaped, "\!"}]
    assert tokenize("hello \!") == [{:text, "hello"}, {:ws, " "}, "!"]
    assert tokenize("hello !") == [{:text, "hello"}, {:ws, " "}, "!"]
  end

  test "should tokenize whitespace" do
    assert tokenize("Foo\n---\nbar\n") == [
             {:text, "Foo"},
             {:ws, "\n"},
             "-",
             "-",
             "-",
             {:ws, "\n"},
             {:text, "bar"},
             {:ws, "\n"}
           ]

    assert tokenize(" ***\n  ***\n   ***\n") == [
             {:ws, " "},
             "*",
             "*",
             "*",
             {:ws, "\n  "},
             "*",
             "*",
             "*",
             {:ws, "\n   "},
             "*",
             "*",
             "*",
             {:ws, "\n"}
           ]
  end

  test "should tokenize asterisks" do
    assert tokenize("*dude*") == ["*", {:text, "dude"}, "*"]
  end
end
