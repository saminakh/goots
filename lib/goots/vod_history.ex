defmodule Goots.VodHistory do
  use Ecto.Schema
  import Ecto.Query
  alias Goots.{Repo, Utils}

  alias Ecto.Changeset

  schema "vod_history" do
    field :url, :string

    timestamps()
  end

  def changeset(attrs) do
    %__MODULE__{}
    |> Changeset.cast(attrs, [:url])
    |> Changeset.unique_constraint(:url)
    |> validate_url
  end

  def save(url) do
    %{url: url}
    |> changeset
    |> Repo.insert()
  end

  def list_all do
    Repo.all(__MODULE__)
  end

  def get(count) when is_integer(count) and count > 0 do
    from(v in __MODULE__,
      order_by: fragment("RANDOM()"),
      limit: ^count
    )
    |> Repo.all()
  end

  def get(_), do: []

  defp validate_url(cs) do
    url = Changeset.get_field(cs, :url)

    if Utils.valid_url?(url) do
      cs
    else
      Changeset.add_error(cs, :url, "invalid url")
    end
  end
end
