defmodule Goots.Commands do
  use Nostrum.Consumer

  alias Nostrum.{Api, Voice}
  alias Goots.{VodHistory, Queue, Utils}

  @guild_id 231_268_398_523_219_968
  @channel_id 1_029_200_744_475_283_527

  require Logger

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:VOICE_SPEAKING_UPDATE, _, _ws_state}) do
    with true <- can_play?,
         url when not is_nil(url) <- Queue.next() do
      VodHistory.save(url)
      Voice.play(@guild_id, url, :ytdl, realtime: true)
    else
      err ->
        IO.inspect(err)
        :ignore
    end
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
        Api.create_message(
          msg.channel_id,
          "It looks like you want some help with world of warcraft. Try typing: \n '!matt spell_name' \n to get an explanation of the mechanic!"
        )

      "!matt " <> spell ->
        Api.create_message(
          msg.channel_id,
          "It looks like you want help with #{spell}. Did you try standing in it? I hear it gives you haste..."
        )

      "!smol" ->
        path = asset_path("so_smol.ogg", :audio)

        if can_play? do
          raw_data = File.read!(path)
          Voice.play(@guild_id, raw_data, :pipe)
        else
          Logger.info("Not connected")
        end

      "!honk" ->
        path = asset_path("honk.ogg", :audio)

        if can_play? do
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
        maybe_play(url, msg.channel_id)

      _ ->
        :ignore
    end
  end

  def handle_event(_event) do
    :noop
  end

  defp maybe_play(url, channel_id) do
    cond do
      !Utils.valid_url?(url) ->
        Api.create_message(channel_id, "This doesn't appear to be a valid url...")

      !can_play? ->
        Api.create_message(
          channel_id,
          "Added to queue! See the vod history and queue at https://goots-web.onrender.com"
        )

        Queue.add(url)

      true ->
        Api.create_message(
          channel_id,
          "Playing now! See the vod history and queue at https://goots-web.onrender.com"
        )

        VodHistory.save(url)
        Voice.play(@guild_id, url, :ytdl, realtime: true)
    end
  end

  defp can_play?, do: Voice.ready?(@guild_id) && !Voice.playing?(@guild_id)

  defp asset_path(filename, :image),
    do: Path.join([:code.priv_dir(:goots), "static", "images", filename])

  defp asset_path(filename, :audio),
    do: Path.join([:code.priv_dir(:goots), "static", "sounds", filename])
end
