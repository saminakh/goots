defmodule GootsWeb.PageController do
  use GootsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
