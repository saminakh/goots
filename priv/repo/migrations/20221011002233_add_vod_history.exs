defmodule Goots.Repo.Migrations.VodHistory do
  use Ecto.Migration

  def change do
    create table(:vod_history) do
      add :url, :string

      timestamps()
    end
  end
end
