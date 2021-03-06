defmodule Sugarcane.Schemas.Guilds do
  use Ecto.Schema

  schema "guilds" do
    field :guild_id, :string
    field :prefix, :string, default: "."
    field :premium, :boolean, default: false
  end
  
  def get(id) do
    case Sugarcane.Repo.get_by(Sugarcane.Schemas.Guilds, guild_id: id) do
      nil -> Sugarcane.Repo.insert(%Sugarcane.Schemas.Guilds{guild_id: id})
      data -> data
    end
  end
end
