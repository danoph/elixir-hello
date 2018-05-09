defmodule Hello.Users.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :linked_in_profile_id, :string
    field :oauth_linked_in_token, :string
    field :password_hash, :string
    field :password_reset_at, :naive_datetime
    field :password_reset_hash, :string
    field :system_role, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email, :password_hash, :oauth_linked_in_token, :linked_in_profile_id, :system_role, :password_reset_hash, :password_reset_at])
    |> validate_required([:first_name, :last_name, :email, :password_hash, :system_role])
    |> unique_constraint(:email)
  end
end
