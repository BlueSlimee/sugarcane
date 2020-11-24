defmodule Sugarcane.Context do
  alias Nostrum.Api
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
    case reason do
      :ma -> reply(ctx, ":x: Nope, wrong usage.\nCorrect usage: `#{ctx.guild_data.prefix}#{cmd.name()} #{cmd.usage()}`")
      :bdo -> reply(ctx, ":x: Scram!")
      :rhm -> reply(ctx, ":x: I can't interact with that user because they either have a role higher than mine, or they are as high as I am on the member list. Fix that, and try again.")
      :ude -> reply(ctx, ":x: I didn't find the user you mentioned?\nMake sure that you're either mentioning the user, or using their ID.")
      :ump -> reply(ctx, ":x: You are not authorized to execute this command.\nyou need the **#{additional}** permission in order to use this command.")
      :cmp -> reply(ctx, ":x: I can't execute this command because I don't have the **#{additional}** permission.")
      _ -> reply(ctx, ":question: Something went wrong. Try again?")
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
            {:error, _} -> :error
          end
      end
    end
  end

  def get_guild_by_id(arg) do
    id = String.replace(is_integer(arg) && Integer.to_string(arg) || arg, :binary.compile_pattern(["@", "!", ">", "<"]), "")
    
    if String.length(id) > 15 and String.length(id) < 20 do
      case Nostrum.Cache.GuildCache.get(String.to_integer(id)) do
        {:ok, guild} -> guild
        _ ->
          case Api.get_guild(String.to_integer(id)) do
            {:ok, user} -> user
            {:error, _} -> :error
          end
      end
    end
  end

  def get_member_by_id(ctx, arg) do
    id = String.replace(is_integer(arg) && Integer.to_string(arg) || arg, :binary.compile_pattern(["@", "!", ">", "<"]), "")
    
    if String.length(id) > 15 and String.length(id) < 20 do
      case get_guild_by_id(Integer.to_string(ctx.msg.guild_id)) do
        :error -> :error
        guild -> case Map.get(guild.members, String.to_integer(id)) do
          nil -> case Api.get_guild_member(ctx.msg.guild_id, String.to_integer(id)) do
            {:ok, m} -> {guild, m}
            {:error, _reason} -> :error
          end
          member -> {guild, member}
        end
      end
    end
  end
  
  def get_me() do
    case Nostrum.Cache.Me.get() do
      nil ->
        case Api.get_current_user() do
          {:ok, d} -> d
          {:error, reason} -> :error
        end
      d -> d
    end
  end
  
  def check_bot_for_perm(ctx, perm, perm_name) do
    case get_member_by_id(ctx, get_me().id) do
      :error -> false
      {guild, member} ->
        if perm in Nostrum.Struct.Guild.Member.guild_permissions(member, guild) do
          true
        else
          reject_action(ctx, nil, :cmp, perm_name)
          false
        end
    end
  end
end