defmodule MyTui do
  use Ratatouille.App

  alias Ratatouille.View
  alias MarkdownTui

  def init(_context) do
    %{
      posts: [
        %{
          title: "An awesome TUI in Elixir",
          body: """
          # Welcome to MyTui

          This is some **sample** text in a paragraph.

          ## Second Heading

          Another line, possibly including *italic* or **bold** text.

          ### Third Heading

          Some more text here, just to test out h3 style.
          """
        }
      ]
    }
  end

  def update(model, msg) do
    case msg do
      # Quit on 'q'
      {:event, %{ch: ?q}} ->
        :quit

      _ ->
        model
    end
  end

  def render(%{posts: posts}) do
    view do
      panel title: "My Elixir TUI" do
        # Render each post
        for post <- posts do
          View.label(content: post.title, attributes: [:bold, :underline])
          View.label(content: "")

          for component <- MarkdownTui.parse_markdown_to_labels(post.body) do
            component
          end
        end

        View.label(content: "Press 'q' to exit", color: :blue)
      end
    end
  end
end

