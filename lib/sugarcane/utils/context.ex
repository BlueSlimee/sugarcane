defmodule Sugarcane.Context do
  alias Nostrum.Api
  defstruct [:msg, :ws_state, :guild_data, :args, :user_data]
  
  def reply(ctx, text) do
    Api.create_message(
      ctx.msg.channel_id,
      content: text,
      allowed_mentions: :user,
      message_reference: %{message_id: ctx.msg.id}
    )
  end

  def reply_embed(ctx, embed) do
    Api.create_message(
      ctx.msg.channel_id,
      embed: embed,
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
      :ma -> reply(ctx, ":x: Errou!\nUtilização correta: `#{ctx.guild_data.prefix}#{cmd.name()} #{cmd.usage()}`")
      :bdo -> reply(ctx, ":x: Evapora!")
      :rhm -> reply(ctx, ":x: Eu não posso interagir com esse usuário por que ele possui uma role maior que a minha, ou está na mesma altura que eu na lista de membros.\nMe dê um cargo mais alto e tente novamente.")
      :ude -> reply(ctx, ":x: Não consegui encontrar o usuário que você mencionou?\nTente usar o ID dele ou mencione-o.")
      :ump -> reply(ctx, ":x: Você não tem permissão para executar este comando.\nVocê precisa da permissão de **#{additional}** para usar esse comando.")
      :cmp -> reply(ctx, ":x: Não posso executar esse comando por que não tenho a permissão de **#{additional}**. Dê ela a mim e tente novamente.")
      _ -> reply(ctx, ":question: Algo deu errado...? Tente novamente, por favor.")
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
          {:error, _reason} -> :error
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

  def create_embed(ctx) do
    %Nostrum.Struct.Embed{}
    |> Nostrum.Struct.Embed.put_color(0x343c34)
    |> Nostrum.Struct.Embed.put_timestamp(DateTime.to_iso8601(DateTime.now!("Etc/UTC")))
    |> Nostrum.Struct.Embed.put_footer("Requisitado por " <> ctx.msg.author.username, Nostrum.Struct.User.avatar_url(ctx.msg.author, "png"))
  end

  def get_ping(ctx) do
    if ctx.ws_state.last_heartbeat_ack do
      DateTime.diff(ctx.ws_state.last_heartbeat_ack, ctx.ws_state.last_heartbeat_send)
    else
      DateTime.diff(DateTime.now!("Etc/UTC"), ctx.ws_state.last_heartbeat_send)
    end
  end
end