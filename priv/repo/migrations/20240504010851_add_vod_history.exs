defmodule Goots.Repo.Migrations.AddVodHistory do
  use Ecto.Migration

  def change do
    create table(:vod_history) do
      add :url, :string

      timestamps()
    end

    create unique_index(:vod_history, [:url])
  end
end
