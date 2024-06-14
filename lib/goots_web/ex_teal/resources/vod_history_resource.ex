defmodule GootsWeb.ExTeal.Resources.VodHistoryResource do
  @moduledoc false
  use ExTeal.Resource

  alias Goots.VodHistory
  alias ExTeal.Fields.{ID, Text}
  @impl true
  def model, do: VodHistory

  @impl true
  def fields, do: [
    ID.make(:id)
  ]
end
