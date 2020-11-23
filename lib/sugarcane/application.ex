defmodule Sugarcane.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Sugarcane.Repo,
      {Plug.Cowboy, scheme: :http, plug: Sugarcane.Routers.Main, options: [port: 4001]},
      Sugarcane.Consumer,
      Sugarcane.Utils.Status
    ]

    Sugarcane.Metrics.setup()

    opts = [strategy: :one_for_one, name: Sugarcane.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
