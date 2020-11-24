defmodule Sugarcane.Commands.Help do
  alias Sugarcane.Context
  
  def name(), do: "help"
  def aliases(), do: ["ajuda"]
  def description(), do: "Mostra comandos do bot"
  def category(), do: "Utilitários"
  
  def run(ctx) do
    embed = Context.create_embed(ctx)
    |> Nostrum.Struct.Embed.put_title("Ajuda do Sugarcane")
    |> add_commands()
    
    Context.reply_embed(ctx, embed)
  end

  def add_commands(embed) do
    cats = Enum.uniq(Enum.map(Sugarcane.Consumer.get_commands(), fn(d) -> d.category() end))
    
    fields = cats
    |> Enum.map(fn(cat) ->
      cmds = Enum.filter(Sugarcane.Consumer.get_commands(), fn(c) -> c.category() == cat end)
      |> Enum.map(fn (a) -> "`#{a.name()}`" end)
      |> Enum.join(" ")
      
      %Nostrum.Struct.Embed.Field{inline: false, name: cat, value: cmds}
    end)
    
    Map.put(embed, :fields, fields)
  end
end