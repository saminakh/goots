defmodule GootsWeb.ExTeal.Policies.ShowAndDelete do
  @moduledoc false
  use ExTeal.Policy

  @impl true
  def create_any?(_), do: false

  @impl true
  def update_any?(_), do: false

  @impl true
  def update?(_, _), do: false

  @impl true
  def delete_any?(_), do: true

  @impl true
  def delete?(_, _), do: true

  @impl true
  def view?(_, _), do: true

  @impl true
  def view_any?(_), do: true
end
