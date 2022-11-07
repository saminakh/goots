defmodule Goots.Release do
  @moduledoc """
  Used for executing DB release tasks when run in production without Mix
  installed.
  """
  @app :goots

  def migrate do
    ensure_started()
    load_app()
    IO.inspect("MIGRATING")

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    ensure_started()
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    IO.inspect("LOADING APP")
    Application.load(@app)
  end

  defp ensure_started do
    IO.inspect("SSL STARTING")
    Application.ensure_all_started(:ssl)
    IO.inspect("SSL STARTED!")
  end
end
