defmodule Chat.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # require IEx
    # IEx.pry()
    :ets.new(:simple_queue_state, [:set, :public, :named_table])

    children = [
      # Starts a worker by calling: Chat.Worker.start_link(arg)
      # {Chat.Worker, arg}
      {Task.Supervisor, name: Chat.TaskSupervisor},
      Chat.SimpleQueue
      # {DynamicSupervisor, strategy: :one_for_one, name: Chat.DynamicSupervisor}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Chat.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
