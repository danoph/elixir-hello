defmodule Hello.Tokens.Token do
  use Ecto.Schema
  import Ecto.Changeset


  schema "tokens" do
    field :token, :string
    belongs_to :user, Hello.Users.User

    timestamps()
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, [:token, :user_id])
    |> validate_required([:token, :user_id])
  end
end
