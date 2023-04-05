defmodule Chat.DynamicSupervisor do
  use DynamicSupervisor
  alias Chat.SlowWorker

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_greeter(name) do
    spec = %{
      id: SlowWorker,
      start: {SlowWorker, :start_link, [%{name: name, from: "DynamicSupervisor"}]}
    }

    DynamicSupervisor.start_child(__MODULE__, spec)
  end
end

# for _i <- 1..5 do
#   name = Faker.Person.first_name()
#   # The DynamicSupervisor starts a worker that sleeps for 5 seconds then puts a greeting
#   spawn(fn -> Chat.DynamicSupervisorWithPartition.start_greeter(name) end)
# end
