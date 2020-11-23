defmodule Sugarcane.Commands.Eval do
  alias Sugarcane.Context
  
  def name(), do: "eval"
  def aliases(), do: ["evaluate"]
  
  def run(ctx) when ctx.msg.author.id == 673677252462116874 do
    try do
      {rst, _bindings} = Code.eval_string(Enum.join(ctx.args, " "), [ctx: ctx])
      Context.reply(ctx, "```elixir\n#{inspect(rst)}\n```")
    rescue
      e in _ -> Context.reply(ctx, ":x: Wrong!\n```elixir\n#{inspect(e)}\n``` ")
    end
  end
  
  def run(ctx) do
    Context.reject_action(ctx, nil, :bdo, nil)
  end
end