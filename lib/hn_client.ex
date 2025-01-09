defmodule HnClient do
  @moduledoc """
  Fetches the top 10 Hacker News story headlines.
  """

  def fetch_top_10 do
    # 1. Get a list of top story IDs
    top_ids =
      Req.get!("https://hacker-news.firebaseio.com/v0/topstories.json").body
      |> Enum.take(10)

    # 2. Fetch each story’s data
    top_stories =
      Enum.map(top_ids, fn id ->
        Req.get!("https://hacker-news.firebaseio.com/v0/item/#{id}.json").body
      end)

    # 3. Extract and return the titles
    Enum.map(top_stories, & &1["title"])
  end
end

