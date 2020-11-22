defmodule Sugarcane.Commands.Ping do
  alias Sugarcane.Context
  
  def name(), do: "ping"
  def aliases(), do: ["pong"]
  
  def run(ctx) do
    {:ok, f, _} = DateTime.from_iso8601(ctx.msg.timestamp)
    diff = DateTime.diff(DateTime.now!("Etc/UTC"), f)
    
    Context.reply(ctx, ":ping_pong: pong! current response time is ~#{diff}ms.")
  end
end