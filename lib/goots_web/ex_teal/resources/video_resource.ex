defmodule GootsWeb.ExTeal.Resources.VideoResource do
  @moduledoc false
  use ExTeal.Resource

  alias Goots.Video
  alias GootsWeb.ExTeal.Policies.ShowAndDelete
  alias ExTeal.Fields.{ID, Text}
  @impl true
  def model, do: Video

  @impl true
  def policy, do: ShowAndDelete

  @impl true
  def search, do: [:title, :channel_title]

  @impl true
  def fields,
    do: [
      ID.make(:id),
      Text.make(:title),
      Text.make(:channel_title),
      Text.make(:description) |> hide_from_index(),
      Text.make(:url) |> hide_from_index()
    ]
end
