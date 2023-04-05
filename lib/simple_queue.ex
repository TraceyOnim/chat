defmodule Chat.SimpleQueue do
  use GenServer

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  # server

  def init(state) do
    {:ok,
     state
     |> populate_state(:ets.lookup(:simple_queue_state, "state"))}
  end

  defp populate_state(state, []) do
    state
  end

  defp populate_state(state, [{_key, values}]) do
    state ++ values
  end

  def handle_call(:pop, _, []) do
    {:reply, "Empty stack", []}
  end

  def handle_call(:pop, _, [h | tail]) do
    {:reply, h, tail}
  end

  def handle_call(:show, _, state) do
    {:reply, state, state}
  end

  def handle_call(:stop, _, state) do
    {:stop, {:shutdown, "failure"}, state}
  end

  def handle_cast({:push, element}, state) do
    {:noreply, [element | state]}
  end

  def terminate(reason, state) do
    :ets.insert(:simple_queue_state, {"state", state})
    reason
  end

  # client

  def pop do
    GenServer.call(__MODULE__, :pop)
  end

  def push(element) do
    GenServer.cast(__MODULE__, {:push, element})
  end

  def show do
    GenServer.call(__MODULE__, :show)
  end

  def stop do
    GenServer.call(__MODULE__, :stop)
  end

  # https://blog.appsignal.com/2022/09/20/fix-process-bottlenecks-with-elixir-1-14s-partition-supervisor.html
end
