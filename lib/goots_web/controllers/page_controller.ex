defmodule GootsWeb.PageController do
  use GootsWeb, :controller
  alias Goots.Queue

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    queue = Queue.list()
    render(conn, :home, queue: queue)
  end
end
