defmodule Hello.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;"

    create table(:users) do
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :email, :citext, null: false
      add :password_hash, :string, null: false
      add :oauth_linked_in_token, :string
      add :linked_in_profile_id, :string
      add :system_role, :string
      add :password_reset_hash, :string
      add :password_reset_at, :naive_datetime

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
