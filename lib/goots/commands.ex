defmodule Goots.Commands do
  alias Nostrum.{Api, Voice}
  alias Goots.Player

  @guild_id 231_268_398_523_219_968
  @channel_id 231_268_398_523_219_970

  require Logger

  def message(%{content: content, channel_id: channel_id}), do: handle_msg(content, channel_id)

  def handle_msg("!help", channel_id) do
    msg =
      ~s(!connect : connect goots to channel
        !leave : kick out goots
        !play [url] : plays yt url
        !rand [count] : queues up random songs up to count from database
        !stop : stops playing current song
        !skip : skips current song and autoplays next item in queue
        !empty : empties queue
    )

    Api.create_message(channel_id, msg)
  end

  def handle_msg("!ping", channel_id), do: Api.create_message(channel_id, "pong!")

  def handle_msg("!max", channel_id) do
    path = asset_path("max.jpg", :image)

    Api.create_message(channel_id,
      content: "I love you Christopher UWU",
      file: path
    )
  end

  def handle_msg("!blidd", channel_id) do
    path = asset_path("blidd#{Enum.random(1..6)}.jpeg", :image)

    Api.create_message(channel_id,
      content: "meow meow",
      file: path
    )
  end

  def handle_msg("!matt", channel_id) do
    Api.create_message(
      channel_id,
      "It looks like you want some help with world of warcraft. Try typing: \n '!matt spell_name' \n to get an explanation of the mechanic!"
    )
  end

  def handle_msg("!matt" <> spell, channel_id) do
    Api.create_message(
      channel_id,
      "It looks like you want help with #{spell}. Did you try standing in it? I hear it gives you haste..."
    )
  end

  def handle_msg("!smol", _channel_id) do
    path = asset_path("so_smol.ogg", :audio)

    if Player.can_play?() do
      raw_data = File.read!(path)
      Voice.play(@guild_id, raw_data, :pipe)
    end
  end

  def handle_msg("!honk", _channel_id) do
    path = asset_path("honk.ogg", :audio)

    if Player.can_play?() do
      raw_data = File.read!(path)
      Voice.play(@guild_id, raw_data, :pipe)
    end
  end

  def handle_msg("!connect", _channel_id), do: Voice.join_channel(@guild_id, @channel_id)

  def handle_msg("!leave", _channel_id), do: Voice.leave_channel(@guild_id)

  def handle_msg("!stop", _channel_id), do: Player.stop()

  def handle_msg("!skip", _channel_id), do: Player.skip()

  def handle_msg("!empty", _channel_id), do: Player.empty()

  def handle_msg("!play " <> url, channel_id),
    do:
      url
      |> Player.add_song()
      |> handle_response(channel_id)

  def handle_msg("!rand " <> count, channel_id),
    do:
      count
      |> Player.add_random()
      |> handle_response(channel_id)

  def handle_msg(_msg, _channel_id), do: :ignore

  defp asset_path(filename, :image),
    do: Path.join([:code.priv_dir(:goots), "static", "images", filename])

  defp asset_path(filename, :audio),
    do: Path.join([:code.priv_dir(:goots), "static", "sounds", filename])

  defp handle_response({:ok, :added_to_queue}, channel_id),
    do: Api.create_message(channel_id, "Added to queue!")

  defp handle_response({:ok, :playing}, channel_id),
    do: Api.create_message(channel_id, "Playing now!")

  defp handle_response({:error, :invalid_url}, channel_id),
    do: Api.create_message(channel_id, "This doesn't appear to be a valid url...")

  defp handle_response({:error, :empty_queue}, channel_id),
    do: Api.create_message(channel_id, "No songs to queue up")

  defp handle_response({:error, :invalid_count}, channel_id),
    do:
      Api.create_message(
        channel_id,
        "This doesn't appear to be a valid count..."
      )
end
