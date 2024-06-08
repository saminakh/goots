defmodule Goots.Repo.Migrations.BackfillYtMetadata do
  use Ecto.Migration
  alias Goots.{Repo, VodHistory, Youtube}
  import Ecto.Query

  def up do
    Repo.transaction(fn ->
      VodHistory
      |> where([v], is_nil(v.title))
      |> Repo.stream()
      |> Stream.each(fn %VodHistory{url: url} = v ->
        case Youtube.get_video_metadata(url) do
          {:ok, metadata} ->
            v
            |> VodHistory.changeset(metadata)
            |> Repo.update()

          err ->
            err
        end
      end)
      |> Stream.run()
    end)
  end

  def down do
    :ok
  end
end
