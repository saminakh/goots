defmodule Mix.Tasks.ReprocessVideoMetadata do
  @moduledoc """
  Task for reprocessing videos that dont have yt metadata
  """

  use Mix.Task
  require Logger

  alias Goots.{Repo, Video}
  import Ecto.Query

  def run(_) do
    Mix.Task.run("app.start")
    Logger.info("Reprocessing yt metadata")

    Repo.transaction(fn ->
      Video
      |> where([v], is_nil(v.title))
      |> Repo.stream()
      |> Stream.each(fn v ->
        Video.maybe_add_metadata(v)
      end)
      |> Stream.run()
    end)
  end
end
