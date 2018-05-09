defmodule Hello.Tokens.Token do
  use Ecto.Schema
  import Ecto.Changeset


  schema "tokens" do
    field :token, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, [:token])
    |> validate_required([:token])
  end
end
