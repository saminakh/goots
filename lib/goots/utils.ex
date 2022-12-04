defmodule Goots.Utils do
  def valid_url?(nil), do: false

  def valid_url?(url) do
    %URI{scheme: scheme, host: host} = URI.parse(url)
    scheme != nil && host != nil && host =~ "."
  end
end
