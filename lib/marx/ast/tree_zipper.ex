defmodule Marx.AST.TreeZipper do
  @moduledoc false
  # A data structure for building and manipulating AST

  def new do
    root = {:document, {[], []}}

    # {{left, right}, up}
    {{[], [root]}, []}
  end

  def insert_before(zipper, value) do
  end

  # Insert at the current focus, taking the focus.
  # The previous focus becomes the next
  def insert({{left, right}, thread}, value) do
    value =
      if is_atom(value) or is_binary(value) do
        {value, {[], []}}
      else
        value
      end

    {{left, [value | right]}, thread}
  end

  def insert_after(zipper, value) do
  end

  # Convert the zipper back to AST
  def to_ast({{left, right}, []}) do
    Enum.map(Enum.reverse(left) ++ right, &to_ast/1)
  end

  def to_ast(zipper) do
    up(zipper)
  end

  def from_ast({:document, children}) do
    {{[], [{:document, {[], Enum.map(children, &from_ast/1)}}]}, []}
  end

  def from_ast({tag, children}) do
    {tag, {[], Enum.map(children, &from_ast/1)}}
  end

  def from_ast(value) do
    {value, {[], []}}
  end

  # Returns the children of the current focus
  def children({{_left, [{_right, children} | _]}, _thread}), do: children

  def down({{left, [{val, children} | right]}, thread}) do
    {children, [{left, [val | right]} | thread]}
  end

  def up({children, [{left, [val | right]} | thread]}) do
    {{left, [{val, children} | right]}, thread}
  end

  # Move to the previous element
  def prev({{[], _right}, _thread}), do: nil

  def prev({{[head | tail], right}, thread}) do
    {{tail, [head | right]}, thread}
  end

  def next({{left, [head | right]}, thread}) do
    {{[head | left], right}, thread}
  end
end
