defmodule Marx.AST do
  @moduledoc """
  Markdown Abstract Syntax Tree
  """

  defstruct []

  @doc """
  Convert the Markdown AST into HTML AST
  """
  def to_html_ast(%__MODULE__{}, _opts) do
    []
  end
end
