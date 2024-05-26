defmodule Goots.Player do
  @moduledoc """
  Module for voice player
  """
  alias Nostrum.Voice
  alias Goots.{VodHistory, Queue, Utils}

  @ytdl_config [realtime: true, volume: 0.5]

  @guild_id 231_268_398_523_219_968

  def play_next() do
    with true <- can_play?(),
         url when not is_nil(url) <- Queue.next() do
      play_now(url)
    else
      _ -> :ignore
    end
  end

  def add_song(url) do
    cond do
      !Utils.valid_url?(url) ->
        {:error, :invalid_url}

      !can_play?() ->
        Queue.add(url)
        {:ok, :added_to_queue}

      true ->
        play_now(url)
        {:ok, :playing}
    end
  end

  def add_random(count) do
    with {num, ""} <- Integer.parse(count),
         song_list <- VodHistory.get(num) do
      play_list(song_list)
    else
      _ ->
        {:error, :invalid_count}
    end
  end

  def stop(), do: Voice.stop(@guild_id)

  def skip() do
    stop()
    :timer.sleep(1000)
    play_next()
  end

  def empty() do
    stop()
    Queue.reset()
  end

  def can_play?(), do: Voice.ready?(@guild_id) && !Voice.playing?(@guild_id)

  defp play_now(url) do
    VodHistory.save(url)
    Voice.play(@guild_id, url, :ytdl, @ytdl_config)
  end

  defp play_list([]), do: {:error, :empty_queue}
  defp play_list(%VodHistory{url: url}), do: add_song(url)
  defp play_list([%VodHistory{url: url}]), do: add_song(url)

  defp play_list([%VodHistory{url: url} | urls]) do
    add_song(url)
    Enum.each(urls, &Queue.add(&1.url))
  end
end
