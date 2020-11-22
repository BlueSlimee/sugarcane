defmodule Sugarcane.Consumer do
  use Nostrum.Consumer
  alias Sugarcane.Context
  
  def start_link do
    Consumer.start_link __MODULE__
  end
  
  def get_commands do
    [
      Sugarcane.Commands.Ping,
      Sugarcane.Commands.Eval
    ]
  end
  
  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) when is_integer(msg.guild_id)
                                                      or not msg.author.bot
                                                      or msg.author.id != 779748651035131945
                                                      do
    guild = Sugarcane.Schemas.Guilds.get(Integer.to_string(msg.guild_id))
    pattern = :binary.compile_pattern([guild.prefix, "sugarcane,", "<@779748651035131945>"])
    
    if String.starts_with?(msg.content, pattern) do
      particles = msg.content
      |> String.split(" ", trim: true)
    
      [command_name | args] = particles
      command_name = String.replace(String.downcase(command_name), pattern, "")
    
      ctx = %Context{msg: msg, args: args, guild_data: guild}
      commands = get_commands()
      cmd = commands
      |> Enum.filter(fn(c) -> c.name == command_name or Enum.member?(c.aliases, command_name) end)
      |> List.first()
      
      if cmd != nil do
        Nostrum.Api.start_typing(msg.channel_id)
        cmd.run(ctx)
      end
    end
  end
  
  def handle_event(_event) do
    :noop
  end
end