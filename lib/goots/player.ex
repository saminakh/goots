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
        save_song(url)
        {:ok, :added_to_queue}

      true ->
        Queue.add(url)
        save_song(url)
        play_next()
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

  def list(), do: Queue.list()

  defp play_now(url) do
    Voice.play(@guild_id, url, :ytdl, @ytdl_config)
  end

  defp play_list(%VodHistory{} = v), do: play_list([v])

  defp play_list(song_list) when is_list(song_list),
    do: Enum.each(song_list, &add_song(&1.url))

  defp play_list(_), do: {:error, :invalid_random}

  defp save_song(url) do
    case VodHistory.save(url) do
      {:ok, v} -> VodHistory.maybe_add_metadata(v)
      _ -> {:error, :failed_to_save}
    end
  end
end
