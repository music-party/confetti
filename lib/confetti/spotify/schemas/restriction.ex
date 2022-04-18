defmodule Confetti.Spotify.Schemas.Restriction do
  use Ecto.Schema
  import Ecto.Changeset

  @required ~w()a
  @primary_key false
  embedded_schema do
    field :reason, :string
  end

  @doc false
  def changeset(restriction, params \\ %{}) do
    restriction
    |> cast(params, [] ++ @required)
    |> validate_inclusion(:reason, ["market", "product", "explicit"])
  end
end
