defmodule GootsWeb.ExTeal.Manifest do
  @moduledoc false
  use ExTeal.Manifest
  alias GootsWeb.Endpoint
  alias GootsWeb.ExTeal.Resources.VodHistoryResource

  def application_name, do: "goots admin"

  def logo_image_path, do: "#{Endpoint.url()}/images/favicon.png"

  def resources, do: [VodHistoryResource]

  def plugins, do: []

  # defaults to /teal
  def path, do: "/admin"
end
