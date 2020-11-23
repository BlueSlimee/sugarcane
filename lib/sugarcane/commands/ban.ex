defmodule Sugarcane.Commands.Ban do
  alias Sugarcane.Context
  
  def name(), do: "ban"
  def aliases(), do: ["banir"]
  def usage(), do: "<member> <reason?>"
  
  def run(ctx) when length(ctx.args) == 0 do
    Context.reject_action(ctx, Sugarcane.Commands.Ban, :ma, nil)
  end
  
  def run(ctx) do
    {guild, punisher} = Context.get_member_by_id(ctx, ctx.msg.author.id)
    punishee = Context.get_user_by_id(List.first(ctx.args))
    
    if punishee == nil do
      Context.reject_action(ctx, nil, :ude, nil)
    else
      if :ban_members in Nostrum.Struct.Guild.Member.guild_permissions(punisher, guild) do
        if Context.check_bot_for_perm(ctx, :ban_members, "ban members") do
          take_action(
            ctx,
            punisher.user,
            punishee.id,
            List.delete_at(ctx.args, 0) |> Enum.join(" ")
          )
        end
      else
        Context.reject_action(ctx, nil, :ump, "ban members")
      end
    end
  end
  
  def take_action(ctx, punisher, user_id, reason) do
    Nostrum.Api.create_guild_ban(
      ctx.msg.guild_id,
      user_id,
      30,
      "punished by #{punisher.username}##{punisher.discriminator} (#{punisher.id}): #{reason}"
    )
  end
end