defmodule HnClient do
  @moduledoc """
  Fetches top stories from Hacker News and prints the first 10 headlines.
  """

  def fetch_top_10 do
    # 1. Get a list of top story IDs from the Hacker News API
    top_ids =
      Req.get!("https://hacker-news.firebaseio.com/v0/topstories.json")
      |> then(fn %Req.Response{body: body} -> body end)
      # Body is a huge list of story IDs, so we'll take the first 10
      |> Enum.take(10)

    # 2. For each ID, fetch the story data
    top_stories =
      top_ids
      |> Enum.map(fn id ->
        Req.get!("https://hacker-news.firebaseio.com/v0/item/#{id}.json").body
      end)

    # 3. Extract the "title" from each story
    # And map them into a nice numbered list
    Enum.with_index(top_stories, 1)
    |> Enum.map(fn {story, i} ->
      "#{i}. #{story["title"]}"
    end)
  end

  def print_top_10 do
    fetch_top_10()
    |> Enum.each(&IO.puts/1)
  end
end

