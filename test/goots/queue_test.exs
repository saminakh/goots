defmodule Goots.QueueTest do
  use Goots.DataCase
  alias Goots.Queue

  describe "add" do
    test "it adds an item to the queue" do
      assert current_state() == []
      Queue.add("song1")
      assert current_state() == ["song1"]

      Queue.reset()
      assert current_state() == []
    end
  end

  describe "list" do
    test "it lists all items in the queue" do
      assert current_state() == []
      assert Queue.list() == []
      Queue.add("song1")
      assert Queue.list() == ["song1"]
      assert current_state() == ["song1"]

      Queue.reset()
      assert current_state() == []
    end
  end

  describe "next" do
    test "it removes the top item from the queue and returns it" do
      Queue.add("song1")
      Queue.add("song2")
      assert current_state() == ["song1", "song2"]
      assert "song1" == Queue.next()
      assert current_state() == ["song2"]

      Queue.reset()
      assert current_state() == []
    end

    test "it handles having 0 items in the queue" do
      assert current_state() == []
      assert nil == Queue.next()
      assert current_state() == []
    end
  end

  defp pid, do: GenServer.whereis(Queue)
  defp current_state, do: :sys.get_state(pid())
end
