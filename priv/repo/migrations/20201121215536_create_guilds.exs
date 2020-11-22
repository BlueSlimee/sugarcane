defmodule Sugarcane.Repo.Migrations.CreateGuilds do
  use Ecto.Migration

  def change do
    create table(:guilds) do
      add :guild_id, :string, null: false
      add :prefix, :string, default: "."
      add :premium, :bool, default: false
    end
  end
end
