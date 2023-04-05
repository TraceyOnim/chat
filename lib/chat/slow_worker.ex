defmodule Chat.SlowWorker do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end

  def init(state) do
    :timer.sleep(5000)
    send(self(), :greet)
    {:ok, state}
  end

  def handle_info(:greet, %{name: name, from: from} = state) do
    IO.puts("Hello from #{from}, #{name}")
    {:noreply, state}
  end
end
