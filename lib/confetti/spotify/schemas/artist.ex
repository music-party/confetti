defmodule Confetti.Spotify.Schemas.Artist do
  use Ecto.Schema
  import Ecto.Changeset

  @required ~w(id name uri)a
  @primary_key false
  embedded_schema do
    field :id, :string, primary_key: true
    field :name, :string
    field :uri, :string
  end

  @doc false
  def changeset(artist, attrs \\ %{}) do
    artist
    |> cast(attrs, [] ++ @required)
    |> validate_required(@required)
  end
end
