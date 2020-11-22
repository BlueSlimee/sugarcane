defmodule Sugarcane.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Sugarcane.Repo, []},
      Sugarcane.Consumer
    ]

    opts = [strategy: :one_for_one, name: Sugarcane.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
