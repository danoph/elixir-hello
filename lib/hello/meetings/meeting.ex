defmodule Hello.Meetings.Meeting do
  use Ecto.Schema
  import Ecto.Changeset


  schema "meetings" do
    field :description, :string
    field :name, :string
    field :shortcode, :string
    field :status, :string
    field :created_by_user_id, :id

    timestamps()
  end

  @doc false
  def changeset(meeting, attrs) do
    meeting
    |> cast(attrs, [:name, :description, :status, :shortcode])
    |> validate_required([:name, :description, :status, :shortcode])
  end
end
