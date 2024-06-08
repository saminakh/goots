defmodule Goots.QueueTest do
  use Goots.DataCase
  alias Goots.Queue

  describe "add" do
    test "it adds an item to the queue" do
      assert queue_state() == []
      Queue.add("song1")
      assert queue_state() == ["song1"]

      Queue.reset()
      assert queue_state() == []
    end
  end

  describe "list" do
    test "it lists all items in the queue" do
      assert queue_state() == []
      assert Queue.list() == []
      Queue.add("song1")
      assert Queue.list() == ["song1"]
      assert queue_state() == ["song1"]

      Queue.reset()
      assert queue_state() == []
    end
  end

  describe "next" do
    test "it removes the top item from the queue and returns it" do
      Queue.add("song1")
      Queue.add("song2")
      assert queue_state() == ["song1", "song2"]
      assert "song1" == Queue.next()
      assert queue_state() == ["song2"]

      Queue.reset()
      assert queue_state() == []
    end

    test "it handles having 0 items in the queue" do
      assert queue_state() == []
      assert nil == Queue.next()
      assert queue_state() == []
    end
  end

  defp pid, do: GenServer.whereis(Queue)
  defp queue_state do
    case :sys.get_state(pid()) do
      %{queue: queue} -> queue
      _ -> {:error, :cant_get_process}
    end
  end
end
