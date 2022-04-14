defmodule Marx do
  @moduledoc """
  A Markdown compiler for the people.

  Provides tools for translating [CommonMark](https://commonmark.org)
  into various intermediate forms. Marx supports extensions to Markdown,
  specifically, Github Flavored Markdown.

  * `Marx.to_ast!/2` - Converts `Markdown (text)` -> `Marx.AST`
  * `Marx.AST.to_html_ast/2` - Converts `Mark.AST` -> `Marx.HTML.AST`
  * `Marx.HTML.to_html/2` - Converts `Marx.HTML.AST` -> `HTML (text)`
  """

  @doc """

  """
  def to_ast!(text, _opts) do
    text
    |> Marx.Tokenizer.tokenize()
    |> Marx.Parser.parse!()
  end

  @spec render(any, any) :: any
  @doc """
  Convert Markdown text directly to HTML

      iex> Marx.render("*foo bar*")
      "<p><em>foo bar</em></p>"
  """
  def render(text, _opts \\ []) do
  end
end
