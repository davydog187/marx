defmodule Marx.AST do
  @moduledoc """
  Markdown Abstract Syntax Tree
  """

  @type t :: {atom(), [t() | String.t()]}

  @doc """
  Convert the Markdown AST into HTML AST
  """
  def to_html_ast(_ast, _opts) do
    []
  end
end
