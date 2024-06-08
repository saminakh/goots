defmodule Goots.VodHistory do
  use Ecto.Schema
  import Ecto.Query
  alias Goots.{Repo, Utils, Youtube}

  alias Ecto.Changeset

  schema "vod_history" do
    field :url, :string
    field :title, :string
    field :description, :string
    field :channel_title, :string
    field :thumbnail_url, :string

    timestamps()
  end

  @fields ~w(url title description channel_title thumbnail_url)a

  def changeset(vod \\ %__MODULE__{}, attrs) do
    vod
    |> Changeset.cast(attrs, @fields)
    |> Changeset.unique_constraint(:url)
    |> validate_url
  end

  def save(url) do
    %{url: url}
    |> changeset
    |> Repo.insert()
  end

  def add_metadata(%__MODULE__{url: url} = v) do
    case Youtube.get_video_metadata(url) do
      {:ok, metadata} ->
        v
        |> changeset(metadata)
        |> Repo.update()

      _ ->
        {:error, :invalid_metadata}
    end
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

  def get_by_urls(url) when not is_list(url), do: get_by_urls([url])

  def get_by_urls(urls) when is_list(urls) do
    __MODULE__
    |> where([u], u.url in ^urls)
    |> Repo.all()
  end

  defp validate_url(cs) do
    url = Changeset.get_field(cs, :url)

    if Utils.valid_url?(url) do
      cs
    else
      Changeset.add_error(cs, :url, "invalid url")
    end
  end
end
