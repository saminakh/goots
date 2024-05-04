defmodule Goots.Queue do
  use GenServer

  @impl true
  def init(_ \\ []) do
    {:ok, []}
  end

  @impl true
  def handle_call(:list, _from, state) do
    {:reply, Enum.reverse(state), state}
  end

  @impl true
  def handle_call(:reset, _from, _state) do
    {:reply, [], []}
  end

  @impl true
  def handle_call(:dequeue, _from, []) do
    {:reply, nil, []}
  end

  @impl true
  def handle_call(:dequeue, _from, [item | state]) do
    {:reply, item, state}
  end

  @impl true
  def handle_cast({:enqueue, item}, state) do
    {:noreply, state ++ [item]}
  end

  def start_link(_state) do
    {:ok, _pid} = GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def add(item) do
    GenServer.cast(__MODULE__, {:enqueue, item})
  end

  def next() do
    GenServer.call(__MODULE__, :dequeue)
  end

  def list do
    GenServer.call(__MODULE__, :list)
  end

  def reset do
    GenServer.call(__MODULE__, :reset)
  end
end
