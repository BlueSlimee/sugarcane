defmodule Sugarcane.Schemas.Punishments do
  use Ecto.Schema
  
  schema "punishments" do
    field :user_id, :string
    field :guild_id, :string
    field :type, :string, default: "warn"
    field :reason, :string, default: "-no reason was given-"
  end
  
  def get(id) do
    data = Sugarcane.Repo.get_by(Sugarcane.Schemas.Punishments, user_id: id)
    
    case data do
      nil -> Sugarcane.Repo.insert(%Sugarcane.Schemas.Punishments{user_id: id})
      _ -> data
    end
  end
  
  def create(user_id, guild_id, type, reason) do
    Sugarcane.Repo.insert(%Sugarcane.Schemas.Punishments{user_id: user_id, guild_id: guild_id, type: type, reason: reason})
  end
end