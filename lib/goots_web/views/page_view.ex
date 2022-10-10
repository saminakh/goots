defmodule GootsWeb.PageView do
  use GootsWeb, :view

  alias Goots.VodHistory

  def list_vods, do: VodHistory.list_all()
end
