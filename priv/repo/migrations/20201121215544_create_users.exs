defmodule Sugarcane.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :user_id, :string, null: false
      add :blacklisted, :bool, default: false
      add :bl_reason, :string, default: ""
    end
  end
end
