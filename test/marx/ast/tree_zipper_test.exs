defmodule Marx.AST.TreeZipperTest do
  use ExUnit.Case

  alias Marx.AST.TreeZipper, as: Zipper

  describe "new/0" do
    test "should return an empty document" do
      assert Zipper.new() == {{[], [document: {[], []}]}, []}
    end
  end

  describe "to_ast/1 and from_ast/1" do
    setup :example_1

    test "can convert a simple AST to a Zipper" do
      ast = {:document, [{:paragraph, ["one"]}, {:paragraph, ["two"]}]}
      zipper = Zipper.from_ast(ast)

      assert zipper == {
               {
                 [],
                 [
                   document:
                     {[],
                      [paragraph: {[], [{"one", {[], []}}]}, paragraph: {[], [{"two", {[], []}}]}]}
                 ]
               },
               []
             }

      assert Zipper.to_ast(zipper)
    end

    test "should create a zipper from an AST", %{ast: ast} do
      assert Zipper.from_ast(ast) == []
      assert ast |> Zipper.from_ast() |> Zipper.to_ast() == ast
    end

    test "moving through the zipper should not effect the output", %{zipper: zipper, ast: ast} do
      assert zipper |> Zipper.down() |> Zipper.down() |> Zipper.next() |> Zipper.to_ast() == ast
    end
  end

  describe "down/1" do
    setup :example_1

    test "should move down to the first child of the current focus", %{zipper: zipper} do
      assert Zipper.new() |> Zipper.down() == {{[], []}, [{[], [:document]}]}

      assert zipper |> Zipper.down() ==
               {{[],
                 [
                   block_quote:
                     {[],
                      [
                        paragraph: {[], [{"hello", {[], []}}]},
                        paragraph: {[], [{"world", {[], []}}]}
                      ]}
                 ]}, [{[], [:document]}]}

      assert zipper |> Zipper.down() |> Zipper.down() ==
               {{[],
                 [paragraph: {[], [{"hello", {[], []}}]}, paragraph: {[], [{"world", {[], []}}]}]},
                [{[], [:block_quote]}, {[], [:document]}]}
    end
  end

  describe "insert_before/2" do
    test "should insert a value before the current node" do
    end
  end

  defp example_1(_context) do
    ast = {:document, [{:block_quote, [{:paragraph, ["hello"]}, {:paragraph, ["world"]}]}]}

    zipper =
      Zipper.new()
      |> Zipper.down()
      |> Zipper.insert(:block_quote)
      |> Zipper.down()
      |> paragraph("world")
      |> paragraph("hello")
      |> Zipper.up()
      |> Zipper.up()

    %{ast: ast, zipper: zipper}
  end

  defp paragraph(zipper, text) do
    zipper |> Zipper.insert(:paragraph) |> Zipper.down() |> Zipper.insert(text) |> Zipper.up()
  end
end
