defmodule Sugarcane.Repo.Migrations.CreatePunishments do
  use Ecto.Migration

  def change do
    create table(:punishments) do
      add :user_id, :string, null: false
      add :guild_id, :string, null: false
      add :type, :string, default: "warn"
      add :reason, :string, default: "-no reason was given-"
    end
  end
end
