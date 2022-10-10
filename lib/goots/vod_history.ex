defmodule Goots.VodHistory do
  use Ecto.Schema
  alias Goots.Repo

  alias Ecto.Changeset

  schema "vod_history" do
    field :url, :string

    timestamps()
  end

  def changeset(attrs) do
    %__MODULE__{}
    |> Changeset.cast(attrs, [:url])
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

  defp validate_url(cs) do
    url = Changeset.get_field(cs, :url)
    %URI{scheme: scheme, host: host} = URI.parse(url)

    case scheme != nil && host != nil && host =~ "." do
      [] ->
        cs

      _ ->
        Changeset.add_error(cs, :url, "invalid url")
    end
  end
end
