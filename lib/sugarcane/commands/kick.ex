defmodule Sugarcane.Commands.Kick do
  alias Sugarcane.Context
  
  def name(), do: "kick"
  def aliases(), do: ["kickar"]
  def category(), do: "Moderação"
  def description(), do: "Expulsa um usuário de seu servidor."
  def usage(), do: "<membro> <razão?>"
  
  def run(ctx) when length(ctx.args) == 0 do
    Context.reject_action(ctx, Sugarcane.Commands.Kick, :ma, nil)
  end
  
  def run(ctx) do
    {guild, punisher} = Context.get_member_by_id(ctx, ctx.msg.author.id)
    punishee = Context.get_user_by_id(List.first(ctx.args))
    
    if punishee == nil do
      Context.reject_action(ctx, nil, :ude, nil)
    else
      if :kick_members in Nostrum.Struct.Guild.Member.guild_permissions(punisher, guild) do
        if Context.check_bot_for_perm(ctx, :kick_members, "expulsar membros") do
          take_action(
            ctx,
            punisher.user,
            punishee,
            List.delete_at(ctx.args, 0) |> Enum.join(" ")
          )
        end
      else
        Context.reject_action(ctx, nil, :ump, "expulsar membros")
      end
    end
  end
  
  def take_action(ctx, punisher, punishee, reason) do
    actual_reason = reason == "" && "motivo não foi especificado." || reason
    case Nostrum.Api.remove_guild_member(
      ctx.msg.guild_id,
      punishee.id,
      "punnido por #{punisher.username}##{punisher.discriminator} (#{punisher.id}): #{actual_reason}"
    ) do
      {:error, _reason} ->
        Context.reject_action(ctx, nil, :rhm, nil)
      _ ->
        Sugarcane.Schemas.Punishments.create(Integer.to_string(punishee.id), Integer.to_string(ctx.msg.guild_id), "kick", actual_reason)
        Context.reply(ctx, ":wave: #{punishee.username} virou uma estrelinha. 🌟.")
    end
  end
end