defmodule Chat do
  @moduledoc """
  Documentation for `Chat`.
  """

  def receive_message(msg) do
    IO.puts(msg)
  end

  def send_message(recipient, msg) do
    Task.Supervisor.async({Chat.TaskSupervisor, recipient}, Chat, :receive_message, [msg])
    |> Task.await()
  end
end
