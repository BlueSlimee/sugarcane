defmodule Sugarcane.Commands.Ping do
  alias Sugarcane.Context
  
  def name(), do: "ping"
  def aliases(), do: ["pong"]
  def description(), do: "Um comando de ping qualquer"
  def category(), do: "Utilitários"
  def run(ctx) do
    {:ok, f, _} = DateTime.from_iso8601(ctx.msg.timestamp)
    diff = DateTime.diff(DateTime.now!("Etc/UTC"), f)
    ping = Context.get_ping(ctx)
    Context.reply(ctx, ":ping_pong: pong! tempo de resposta é de ~#{diff + ping}ms (shard #{ctx.ws_state.shard_num()})")
  end
end