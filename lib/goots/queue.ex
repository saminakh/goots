defmodule Goots.Queue do
  @moduledoc """
  Maintains a queue with 'now playing' field and a 'queue' field
  """
  use GenServer

  @default_state %{
    now_playing: nil,
    queue: []
  }

  @impl true
  def init(_ \\ @default_state) do
    {:ok, @default_state}
  end

  @impl true
  def handle_call(:list, _from, state) do
    {:reply, state.queue, state}
  end

  @impl true
  def handle_call(:reset, _from, _state) do
    {:reply, @default_state, @default_state}
  end

  @impl true
  def handle_call(:dequeue, _from, %{queue: []} = state) do
    {:reply, nil, state}
  end

  @impl true
  def handle_call(:dequeue, _from, %{queue: [item | queue]} = state) do
    {:reply, item, Map.merge(state, %{queue: queue, now_playing: item})}
  end

  @impl true
  def handle_call(:now_playing, _from, %{now_playing: now_playing} = state) do
    {:reply, now_playing, state}
  end

  @impl true
  def handle_cast({:enqueue, item}, %{queue: queue} = state) do
    {:noreply, Map.put(state, :queue, (queue ++ [item]))}
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

  def now_playing do
    GenServer.call(__MODULE__, :now_playing)
  end
end
