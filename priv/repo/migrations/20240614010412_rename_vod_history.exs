defmodule Goots.Repo.Migrations.RenameVodHistory do
  use Ecto.Migration

  def up do
    rename table("vod_history"), to: table("videos")
    flush()
    rename(index(:videos, [:url], name: "vod_history_url_index"), to: "videos_url_index")
    rename(index(:videos, [:id], name: "vod_history_pkey"), to: "videos_pkey")
  end
  def down do
    rename table("videos"), to: table("vod_history")
    flush()
    rename(index(:vod_history, [:url], name: "videos_url_index"), to: "vod_history_url_index")
    rename(index(:vod_history, [:id], name: "videos_pkey"), to: "vod_history_pkey")
  end
end
