defmodule Goots.Repo.Migrations.AddYtMetadata do
  use Ecto.Migration

  def change do
    alter table(:vod_history) do
      add :title, :string
      add :channel_title, :string
      add :description, :text
      add :thumbnail_url, :string
    end
  end
end
