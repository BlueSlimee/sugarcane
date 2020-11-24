defmodule Sugarcane.Commands.Bi do
  alias Sugarcane.Context
  alias Nostrum.Struct.Embed
  def name(), do: "botinfo"
  def aliases(), do: ["bi"]
  def description(), do: "Informações técnicas do bot"
  def category(), do: "Outros"
  
  def run(ctx) do
    {total_gc, bytes_reclaimed, _} = :erlang.statistics(:garbage_collection)
    
    Context.reply_embed(
      ctx,
      Context.create_embed(ctx)
      |> Embed.put_field("Versão do Elixir", System.version())
      |> Embed.put_field("Versão do Erlang/OTP", "#{:erlang.system_info(:otp_release)} (erts-#{:erlang.system_info(:version)})", true)
      |> Embed.put_field("Memória usada", Size.humanize!(:erlang.memory(:total), round: 1), true)
      |> Embed.put_field("Estatísticas do GC", "Executado #{total_gc} vezes, #{Size.humanize!(bytes_reclaimed, round: 1)} limpos da memória", true)
      |> Embed.put_field("Utilização do bot (desde a última reinicialização)", "#{Sugarcane.Metrics.CommandInstrumenter.val()} comandos (#{Sugarcane.Metrics.ProcessedMessageInstrumenter.val()} mensagens processadas)", true)
    )
  end
end