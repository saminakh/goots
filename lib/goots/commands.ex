defmodule Goots.Commands do
  use Nostrum.Consumer

  alias Nostrum.{Api, Voice}
  alias Goots.VodHistory

  @guild_id 0
  @channel_id 0

  require Logger

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    case msg.content do
      "!ping" ->
        Api.create_message(msg.channel_id, "pong!")

      "!max" ->
        path = asset_path("max.jpg", :image)

        Api.create_message(msg.channel_id,
          content: "I love you Christopher UWU",
          file: path
        )

      "!blidd" ->
        path = asset_path("fancycat.jpg", :image)

        Api.create_message(msg.channel_id,
          content: "https://www.designbyhumans.com/shop/Blidd",
          file: path
        )

      "!smol" ->
        path = asset_path("so_smol.ogg", :audio)

        if Voice.ready?(@guild_id) do
          raw_data = File.read!(path)
          Voice.play(@guild_id, raw_data, :pipe)
        else
          Logger.info("Not connected")
        end

      "!connect" ->
        Voice.join_channel(@guild_id, @channel_id)
        Logger.info("Connecting")

      "!leave" ->
        Voice.leave_channel(@guild_id)
        Logger.info("Leaving")

      "!stop" ->
        Voice.stop(@guild_id)
        Logger.info("Stopping")

      "!play " <> url ->
        if Voice.ready?(@guild_id) do
          Api.create_message(msg.channel_id, "Playing: #{url}")
          Voice.play(@guild_id, url, :ytdl, realtime: true)
          VodHistory.save(url)
        else
          Logger.info("Not connected")
        end

      _ ->
        :ignore
    end
  end

  def handle_event(_event) do
    :noop
  end

  defp asset_path(filename, :image),
    do: Path.join([:code.priv_dir(:goots), "static", "images", filename])

  defp asset_path(filename, :audio),
    do: Path.join([:code.priv_dir(:goots), "static", "sounds", filename])
end
