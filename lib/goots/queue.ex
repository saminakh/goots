defmodule Goots.Queue do
  use GenServer

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:list, _from, state) do
    {:reply, state, state}
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
    {:noreply, [item | state]}
  end

  def start_link(state) do
    {:ok, pid} = GenServer.start_link(__MODULE__, state, name: __MODULE__)
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
end
