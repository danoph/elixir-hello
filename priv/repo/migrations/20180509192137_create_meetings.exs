defmodule Hello.Repo.Migrations.CreateMeetings do
  use Ecto.Migration

  def change do
    create table(:meetings) do
      add :name, :string, null: false
      add :description, :string, null: false
      add :status, :string, null: false
      add :shortcode, :citext, null: false
      add :created_by_user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:meetings, [:created_by_user_id])
  end
end
