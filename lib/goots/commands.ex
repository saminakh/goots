defmodule Goots.Commands do
  use Nostrum.Consumer

  alias Nostrum.{Api, Voice}
  alias Goots.VodHistory

  @guild_id 231_268_398_523_219_968
  @channel_id 1_029_200_744_475_283_527

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
        path = asset_path("blidd#{Enum.random(1..6)}.jpeg", :image)

        Api.create_message(msg.channel_id,
          content: "meow meow",
          file: path
        )

      "!matt" ->
        Api.create_message(msg.channel_id, "It looks like you want some help with world of warcraft. Try typing: \n '!matt spell_name' \n to get an explanation of the mechanic!")

      "!matt " <> spell ->
        Api.create_message(msg.channel_id, "It looks like you want help with #{spell}. Did you try standing in it? I hear it gives you haste...")

      "!smol" ->
        path = asset_path("so_smol.ogg", :audio)

        if Voice.ready?(@guild_id) do
          raw_data = File.read!(path)
          Voice.play(@guild_id, raw_data, :pipe)
        else
          Logger.info("Not connected")
        end

      "!honk" ->
        path = asset_path("honk.ogg", :audio)

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
          Api.create_message(msg.channel_id, "Ok! See the vod history and queue at https://goots-web.onrender.com")
          VodHistory.save(url)
          Voice.play(@guild_id, url, :ytdl, realtime: true)
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
