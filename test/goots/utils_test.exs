defmodule Goots.UtilsTest do
  use Goots.DataCase
  alias Goots.Utils

  describe "extra_video_id" do
    test "it pulls out a video id from a url" do
      url = "https://www.youtube.com/watch?v=uGjHsLnUO1U"
      assert Utils.extract_video_id(url) == "uGjHsLnUO1U"
    end

    test "it handles the goofy yt url format" do
      url = "https://youtu.be/uOIa1ClqQcY?si=9sO9LFEctjQHOvT0"
      assert Utils.extract_video_id(url) == "uOIa1ClqQcY"
    end
  end
end
