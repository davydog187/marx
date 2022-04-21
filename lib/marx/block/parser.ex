defmodule Marx.Block.Parser do
  @newlines ["\r\n", "\n", "\r"]

  # Parses out the blocks in the document

  def parse(string) do
    [line | lines] = String.split(string, @newlines)
    meta = %{}
    parse_line(line, lines, [], meta)
  end

  defp parse_line("", [line | lines], blocks, meta) do
    parse_line(line, lines, blocks, meta)
  end

  defp parse_line("", [], blocks, _meta) do
    blocks
  end

  defp parse_line("> " <> line, lines, blocks, meta) do
    parse_bq(line, lines, insert({:block_quote, [], []}, blocks), meta)
  end

  defp parse_line("- " <> line, lines, blocks, meta) do
    # TODO tight can't be determined here
    attrs = [type: :bullet, tight: true, bullet_char: "-"]

    # parse_line(line, lines, push(blocks), meta)
    blocks
  end

  defp parse_line(line, lines, blocks, meta) do
    parse_line("", lines, insert({:paragraph, [], List.wrap(line)}, blocks), meta)
  end

  # Find more block quote indentation
  defp parse_bq("> " <> line, lines, blocks, meta) do
    parse_bq(line, lines, insert(:block_quote, blocks), meta)
  end

  defp parse_bq(line, lines, blocks, meta) do
    parse_line(line, lines, blocks, meta)
  end

  # defp push(items, blocks) do
  #   Enum.reduce(items, blocks, &push/2)
  # end

  defp insert({tag, _, content}, [[{tag, _, _} = block | row] | blocks]) do
    [[concat_block(content, block) | row] | blocks]
  end

  defp insert(item, [row | blocks]) do
    [[item | row] | blocks]
  end

  defp concat_block([block], {tag, params, content}) do
    {tag, params, [block, "\n" | content]}
  end

  defp close_block({tag, attrs, content}) do
    {tag, attrs, Enum.reverse(content)}
  end

  defp collapse(rows) do
    Enum.reduce(rows, [], fn row, blocks ->
      [collapse_row(row) | blocks]
    end)
  end

  defp collapse_row([]), do: []
  defp collapse_row([item]), do: close_block(item)

  defp collapse_row([item | blocks]) do
    item |> close_block() |> insert_into(collapse_row(blocks))
  end

  defp insert_into(item, []), do: item

  defp insert_into(item, {tag, attrs, content}) do
    {tag, attrs, [item] ++ content}
  end
end
