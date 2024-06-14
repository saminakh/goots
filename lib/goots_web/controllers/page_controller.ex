defmodule GootsWeb.PageController do
  use GootsWeb, :controller
  alias Goots.{Queue, Video}

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    items =
      Queue.list()
      |> Video.get_by_urls()

    queue =
      Queue.list()
      |> Enum.map(fn url ->
        Enum.find(items, fn item ->
          item.url == url
        end)
      end)

    now_playing =
      Queue.now_playing()
      |> Video.get_by_urls()
      |> case do
        [item] -> item
        _ -> nil
      end

    render(conn, :home, queue: queue, now_playing: now_playing)
  end
end
