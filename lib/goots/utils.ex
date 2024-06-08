defmodule Goots.Utils do
  @moduledoc """
  Module for url helpers
  """
  @spec valid_url?(String.t() | nil) :: boolean()
  def valid_url?(nil), do: false
  def valid_url?(url) do
    %URI{scheme: scheme, host: host} = URI.parse(url)
    scheme != nil && host != nil && host =~ "."
  end

  @spec extract_video_id(String.t()) :: String.t() | nil
  def extract_video_id(url) do
    url
    |> URI.parse
    |> get_id_from_query
  end

  defp get_id_from_query(%{host: "www.youtube.com", query: q}) do
    case URI.decode_query(q) do
      %{"v" => v} -> v
      _ -> nil
    end
  end

  defp get_id_from_query(%{host: "youtu.be", path: "/" <> p}), do: p
  defp get_id_from_query(_), do: nil
end
