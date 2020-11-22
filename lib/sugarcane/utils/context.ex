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
end