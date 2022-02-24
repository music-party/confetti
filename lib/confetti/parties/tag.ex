defmodule Confetti.Parties.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime_usec]
  schema "tags" do
    belongs_to :party, Party
    field :name, :string
    field :weight, :float

    timestamps()
    field :deleted_at, :utc_datetime_usec, default: nil
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name, :weight])
    |> validate_required([:name, :weight])
  end
end
