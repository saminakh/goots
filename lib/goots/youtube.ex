defmodule Goots.Youtube do
  @moduledoc """
  Module for fetching youtube metadata such as title
  """
  use Tesla
  plug Tesla.Middleware.BaseUrl, "https://www.googleapis.com/youtube/v3"
  plug Tesla.Middleware.JSON

  alias Goots.Utils

  @spec get_video_metadata(String.t()) :: map() | {:error, :invalid_url} | {:error, :invalid_id}
  def get_video_metadata(url) do
    with true <- Utils.valid_url?(url),
         video_id when not is_nil(video_id) <- Utils.extract_video_id(url) do
      fetch_metadata(video_id)
    else
      false -> {:error, :invalid_url}
      _ -> {:error, :invalid_id}
    end
  end

  @spec fetch_metadata(String.t()) :: map() | {:error, String.t()}
  def fetch_metadata(video_id) do
    key = api_key()

    case get("/videos", query: [part: "snippet,contentDetails", id: video_id, key: key]) do
      {:ok, %{status: 200, body: %{"items" => [item | _]}}} ->
        metadata = %{
          title: item["snippet"]["title"],
          description: item["snippet"]["description"],
          channel_title: item["snippet"]["channelTitle"],
          thumbnail_url: item["snippet"]["thumbnails"]["standard"]["url"]
        }

        {:ok, metadata}

      {:ok, %{status: status, body: body}} ->
        {:error, "Error fetching video metadata: #{status} - #{inspect(body)}"}

      {:error, reason} ->
        {:error, "Error fetching video metadata: #{inspect(reason)}"}
    end
  end

  defp api_key do
    with config <- Application.get_env(:goots, Goots.YoutubeMetadata),
         key when not is_nil(key) <- config[:key] do
      key
    else
      _ -> {:error, :no_yt_key_set}
    end
  end
end
