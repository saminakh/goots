defmodule Goots.VideoTest do
  use Goots.DataCase
  alias Goots.Video

  describe "save" do
    test "it saves a new url" do
      url = "https://www.youtube.com/watch?v=8pj-yeqbojk"
      assert Repo.aggregate(Video, :count) == 0
      assert {:ok, %Video{url: ^url}} = Video.save(url)
    end

    test "it doesn't create a new duplicate" do
      assert Repo.aggregate(Video, :count) == 0

      url = "https://www.youtube.com/watch?v=8pj-yeqbojk"
      assert {:ok, %Video{url: ^url}} = Video.save(url)
      assert Repo.aggregate(Video, :count) == 1

      assert {:ok, %Video{url: ^url}} = Video.save(url)
      assert Repo.aggregate(Video, :count) == 1
    end
  end
end
