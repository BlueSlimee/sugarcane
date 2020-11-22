defmodule Sugarcane.Schemas.Users do
  use Ecto.Schema

  schema "users" do
    field :user_id, :string
    field :blacklisted, :boolean, default: false
    field :bl_reason, :string, default: ""
  end
  
  def get(id) do
    data = Sugarcane.Repo.get_by(Sugarcane.Schemas.Users, user_id: id)
    
    case data do
      nil -> Sugarcane.Repo.insert(%Sugarcane.Schemas.Users{user_id: id})
      _ -> data
    end
  end
end
