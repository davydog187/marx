defmodule Marx.Block.ParserTest do
  use ExUnit.Case

  import Marx.Block.Parser, only: [parse: 1]

  @moduledoc """
  Example

  -> document
    -> block_quote
        paragraph
            "Lorem ipsum dolor\nsit amet."
        -> list (type=bullet tight=true bullet_char=-)
            list_item
                paragraph
                    "Qui *quodsi iracundia*"
            -> list_item
                -> paragraph
                    "aliquando id"
  """

  describe "Appendix A: A parsing strategy" do
    test "should build a block tree" do
      example = """
      > Lorem ipsum dolor
      sit amet.
      > - Qui *quodsi iracundia*
      > - aliquando id
      """

      assert parse(example) == [
               {:block_quote, [],
                [
                  {:paragraph, [], ["Lorem ipsum dolor", "sit amet."]},
                  {:list, [], [type: :bullet, tight: true, bullet_char: "-"],
                   [
                     {:list_item, [], {:paragraph, ["Qui *quodsi iracundia*"]}},
                     {:list_item, [], {:paragraph, ["aliquando id"]}}
                   ]}
                ]}
             ]
    end
  end

  describe "Simple documents" do
    test "should parse a single paragraph" do
      assert parse("hello") == [{:paragraph, [], ["hello"]}]
    end

    test "should parse a paragraph continuation" do
      assert parse("hello\nworld") == [{:paragraph, [], ["hello", "\n", "world"]}]
    end

    test "should parse a block quote" do
      assert parse("> one") == [{:block_quote, [], [{:paragraph, [], ["one"]}]}]
    end

    test "should parse a multi-line block quote" do
      assert parse("> one\n> two") == [
               {:block_quote, [], [{:paragraph, [], ["one", "\n", "two"]}]}
             ]
    end

    test "should parse a multi-line block quote paragraph continuation" do
      assert parse("> one\ntwo") == [{:block_quote, [], [{:paragraph, [], ["one", "\n", "two"]}]}]
    end

    test "should parse a block quote and separate paragaph" do
      assert parse("> one\n\ntwo") == [
               {:block_quote, [], [{:paragraph, [], ["one", "\n", "two"]}]}
             ]
    end
  end
end
