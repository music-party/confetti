defmodule Confetti.Parties.Party do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime_usec]
  schema "parties" do
    field :description, :string
    field :name, :string
    field :privacy, Ecto.Enum, values: [:public, :private]
    field :host, :binary_id
    has_many :tags, Tag

    timestamps()
    field :deleted_at, :utc_datetime_usec, default: nil
  end

  @doc false
  def changeset(party, attrs) do
    party
    |> cast(attrs, [:name, :description, :privacy])
    |> validate_required([:name, :description, :privacy])
  end
end
