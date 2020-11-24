defmodule Sugarcane.Consumer do
  use Nostrum.Consumer
  alias Sugarcane.Context
  alias Sugarcane.Commands
  
  def start_link do
    Consumer.start_link __MODULE__
  end
  
  def get_commands do
    [
      Commands.Ping,
      Commands.Eval,
      Commands.Ban,
      Commands.Kick,
      Commands.Bi,
      Commands.Help
    ]
  end
  
  def handle_event({:MESSAGE_CREATE, msg, ws_state}) when is_integer(msg.guild_id) and msg.author.bot != true and msg.author.id != 779748651035131945 do
    Sugarcane.Metrics.ProcessedMessageInstrumenter.inc()
    guild = Sugarcane.Schemas.Guilds.get(Integer.to_string(msg.guild_id))
    pattern = :binary.compile_pattern([guild.prefix, "sugarcane,", "<@779748651035131945>"])
    
    if String.starts_with?(msg.content, pattern) do
      particles = msg.content
      |> String.split(" ", trim: true)

      [command_name | args] = particles
      command_name = String.replace(String.downcase(command_name), pattern, "")
      |> String.trim()

      ctx = %Context{msg: msg, args: args, guild_data: guild, ws_state: ws_state}
      cmd = get_commands()
      |> Enum.filter(fn(c) -> c.name == command_name or Enum.member?(c.aliases, command_name) end)
      |> List.first()
      
      if cmd != nil do
        Sugarcane.Metrics.CommandInstrumenter.inc()
        Nostrum.Api.start_typing(msg.channel_id)
        cmd.run(ctx)
      end
    end
  end
  
  def handle_event(_event) do
    :noop
  end
end