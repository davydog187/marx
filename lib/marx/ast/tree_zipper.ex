defmodule Marx.AST.TreeZipper do
  @moduledoc false
  # A data structure for building and manipulating AST

  alias Marx.AST

  @type zlist(a) :: {prev :: list(a), next :: list(a)}
  @type znode :: zlist({term(), zlist(term())})
  @type thread :: [znode()]
  @type t :: {znode(), thread()}

  @spec new :: t()
  def new do
    root = {:document, {[], []}}

    {{[], [root]}, []}
  end

  # Insert at the current focus, taking the focus.
  # The previous focus becomes the next
  @spec insert(t(), term()) :: t()
  def insert({{left, right}, thread}, value) do
    value =
      if is_atom(value) or is_binary(value) do
        {value, {[], []}}
      else
        value
      end

    {{left, [value | right]}, thread}
  end

  # Convert the zipper back to AST
  @spec to_ast(t()) :: AST.t()
  def to_ast({{[], [{:document, {left, right}}]}, []}) do
    {:document, Enum.map(Enum.reverse(left) ++ right, &convert_to_ast/1)}
  end

  def to_ast(zipper) do
    zipper |> up() |> to_ast()
  end

  defp convert_to_ast({value, {[], []}}) do
    value
  end

  defp convert_to_ast({value, {left, right}}) do
    {value, Enum.map(Enum.reverse(left) ++ right, &convert_to_ast/1)}
  end

  @spec from_ast(AST.t()) :: t()
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

  @spec down(t()) :: t()
  def down({{left, [{val, children} | right]}, thread}) do
    {children, [{left, [val | right]} | thread]}
  end

  @spec up(t()) :: t()
  def up({{_, _}, []} = zipper), do: zipper

  def up({children, [{left, [val | right]} | thread]}) do
    {{left, [{val, children} | right]}, thread}
  end

  # Move to the previous element
  @spec prev(t()) :: t() | nil
  def prev({{[head | tail], right}, thread}) do
    {{tail, [head | right]}, thread}
  end

  @spec next(t()) :: t()
  def next({{left, [head | right]}, thread}) do
    {{[head | left], right}, thread}
  end
end
