defmodule MarkdownTui do
  @moduledoc """
  Convert markdown strings into lists of Ratatouille components.
  """

  alias Ratatouille.View

  @doc """
  Given a markdown string, parse it with Earmark and turn the AST
  into a list of TUI label components (with “big” headings, etc.).
  """
  def parse_markdown_to_labels(markdown_string) do
    # Parse into AST using Earmark
    {:ok, ast, _} = Earmark.as_ast(markdown_string)
    # Convert AST into label components
    render_ast(ast)
    |> List.flatten()
  end

  # Recursively render the AST list
  defp render_ast([]), do: []

  defp render_ast([node | rest]) do
    render_node(node) ++ render_ast(rest)
  end

  # Pattern match various markdown nodes:

  # h1
  defp render_node({"h1", _, content, _}) do
    text = gather_inline_content(content)

    [
      View.label(
        content: text,
        attributes: [:bold, :underline],
        color: :yellow
      ),
      # optional blank line after heading
      View.label(content: "")
    ]
  end

  # h2
  defp render_node({"h2", _, content, _}) do
    text = gather_inline_content(content)

    [
      View.label(
        content: text,
        attributes: [:bold],
        color: :cyan
      ),
      View.label(content: "")
    ]
  end

  # h3
  defp render_node({"h3", _, content, _}) do
    text = gather_inline_content(content)

    [
      View.label(
        content: text,
        # let's differentiate by color or attribute
        attributes: [:bold],
        color: :magenta
      ),
      View.label(content: "")
    ]
  end

  # paragraphs
  defp render_node({"p", _, content, _}) do
    text = gather_inline_content(content)

    [
      View.label(content: text),
      # blank line after paragraphs
      View.label(content: "")
    ]
  end

  # If we hit raw text or anything not matched above
  defp render_node(text) when is_binary(text) do
    [
      View.label(content: text)
    ]
  end

  # Otherwise, ignore
  defp render_node(_other) do
    []
  end

  # Gather inline content from child nodes
  defp gather_inline_content(content) when is_list(content) do
    content
    |> Enum.map(fn
      txt when is_binary(txt) -> txt
      {tag, _, inner, _} ->
        # If you want inline styling, handle it here
        gather_inline_content(inner)
      other ->
        "#{inspect(other)}"
    end)
    |> Enum.join("")
  end

  defp gather_inline_content(other), do: "#{other}"
end

