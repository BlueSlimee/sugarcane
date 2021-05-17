defmodule Sugarcane.Consumer do
  use Nostrum.Consumer

  alias Nostrum.Cache.Me
  alias Nostrum.Struct.User
  alias Sugarcane.{Context, Commands, Utils}
  alias Sugarcane.Commands


  def start_link do
    Consumer.start_link(__MODULE__)
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

    %User{id: bot_id, username: bot_username} = Me.get()
    prefixes = [guild.prefix, "#{bot_username},", to_string(bot_id)]

    if String.contains?(msg.content, prefixes) do
      [command_name | args] =
        msg.content
        |> Utils.remove_first_char()
        |> String.split(" ", trim: true)


      cmd = fetch_command(command_name)

      if cmd != nil do
        ctx = %Context{
          msg: msg,
          args: args,
          guild_data: guild,
          ws_state: ws_state
        }

        Sugarcane.Metrics.CommandInstrumenter.inc()
        Nostrum.Api.start_typing(msg.channel_id)
        cmd.run(ctx)
      end
    end
  end

  # Default event handler, if you don't include this, your consumer WILL crash if
  # you don't have a method definition for each event type.
  def handle_event(_event) do
    :noop
  end

  defp fetch_command(name) when is_binary(name) do
    name = String.downcase(name)

    Enum.find(get_commands(),
     fn cmd ->
      cmd.name() === name or Enum.member?(cmd.aliases(), name)
     end)
  end
end
