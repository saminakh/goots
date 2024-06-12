defmodule Goots.VodHistoryTest do
  use Goots.DataCase
  alias Goots.VodHistory

  describe "save" do
    test "it saves a new url" do
      url = "https://www.youtube.com/watch?v=8pj-yeqbojk"
      assert Repo.aggregate(VodHistory, :count) == 0
      assert {:ok, %VodHistory{url: ^url}} = VodHistory.save(url)
    end

    test "it doesn't create a new duplicate" do
      assert Repo.aggregate(VodHistory, :count) == 0

      url = "https://www.youtube.com/watch?v=8pj-yeqbojk"
      assert {:ok, %VodHistory{url: ^url}} = VodHistory.save(url)
      assert Repo.aggregate(VodHistory, :count) == 1

      assert {:ok, %VodHistory{url: ^url}} = VodHistory.save(url)
      assert Repo.aggregate(VodHistory, :count) == 1
    end
  end
end
