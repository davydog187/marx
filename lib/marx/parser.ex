defmodule Marx.Parser do
  @moduledoc false

  # Parses tokens into Marx.AST

  def parse!(tokens) do
    state = %{}

    handle_token(tokens, [], state)
  end

  defp handle_token(tokens, buffer, state) do
    []
  end
end
