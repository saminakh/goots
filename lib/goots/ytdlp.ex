defmodule Goots.Ytdlp do
  @moduledoc """
  module for preprocessing authenticated audio url

  """
  @cookies_file "/app/cookies.txt"

  def get_audio_url(url) do
    case System.cmd("yt-dlp", ["--cookies", @cookies_file, "-f", "bestaudio", "--get-url", url]) do
      {audio_url, 0} ->
        {:ok, String.trim(audio_url)}

      {err_msg, code} ->
        {:error, "yt-dlp failed with code #{code}: #{err_msg}"}
    end
  end
end
