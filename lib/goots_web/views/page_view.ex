defmodule GootsWeb.PageView do
  use GootsWeb, :view

  alias Goots.{VodHistory, Queue}

  def list_vods, do: VodHistory.list_all()
  def list_queue, do: Queue.list()
end
