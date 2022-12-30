defmodule Goots.Repo.Migrations.MakeUrlsUnique do
  use Ecto.Migration

  def up do
    create unique_index(:vod_history, [:url])
  end

  def down do
    drop index(:vod_history, [:url])
  end
end
