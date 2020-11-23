defmodule Sugarcane.Context do
  alias Nostrum.Api
  alias Nostrum.Cache.GuildCache
  defstruct [:msg, :guild_data, :args, :user_data]
  
  def reply(ctx, text) do
    Api.create_message(
      ctx.msg.channel_id,
      content: text,
      allowed_mentions: :user,
      message_reference: %{message_id: ctx.msg.id}
    )
  end
  
  def react(ctx, emoji) do
    Api.create_reaction(
      ctx.msg.channel_id,
      ctx.msg.id,
      emoji
    )
  end
  
  def reject_action(ctx, cmd, reason, additional) do
    cond do
      reason == :ma -> reply(ctx, ":x: nope, wrong usage.\ncorrect usage: `#{ctx.guild_data.prefix}#{cmd.name()} #{cmd.usage()}`")
      reason == :bdo -> reply(ctx, ":x: scram.")
      reason == :ude -> reply(ctx, ":x: I didn't find the user you mentioned?\nMake sure that you're either mentioning the user, or using their ID.")
      reason == :ump -> reply(ctx, ":x: you are not authorized to execute this command.\nyou need the **#{additional}** permission in order to use this command.")
      reason == :cmp -> reply(ctx, ":x: I can't execute this command because I don't have the **#{additional}** permission.")
    end
  end
  
  def get_user_by_id(arg) do
    id = String.replace(is_integer(arg) && Integer.to_string(arg) || arg, :binary.compile_pattern(["@", "!", ">", "<"]), "")
    
    if String.length(id) > 15 and String.length(id) < 20 do
      case Nostrum.Cache.UserCache.get(String.to_integer(id)) do
        {:ok, user} -> user
        {:error, _reason} ->
          case Api.get_user(String.to_integer(id)) do
            {:ok, user} -> user
            {:error, _} -> nil
          end
      end
    end
  end
  
  def get_member_by_id(ctx, arg) do
    id = String.replace(is_integer(arg) && Integer.to_string(arg) || arg, :binary.compile_pattern(["@", "!", ">", "<"]), "")
    
    if String.length(id) > 15 and String.length(id) < 20 do
      case GuildCache.get(ctx.msg.guild_id) do
        {:ok, guild} ->
          member = Map.get(guild.members, String.to_integer(id))
          {guild, member}
        {:error, _reason} ->
          guild = Api.get_guild!(ctx.msg.guild_id)
          member = Map.get(guild.members, String.to_integer(id))
          {guild, member}
      end
    else
      :error
    end
  end
  
  def check_bot_for_perm(ctx, perm, perm_name) do
    case get_member_by_id(ctx, Nostrum.Cache.Me.get().id) do
      :error -> false
      {guild, member} ->
        if perm in Nostrum.Struct.Guild.Member.guild_permissions(member, guild) do
          true
        else
          Context.reject_action(ctx, nil, :cmp, perm_name)
          false
        end
    end
  end
end