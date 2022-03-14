defmodule Confetti.Spotify.Schemas.Followers do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :href, :string
    field :total, :integer
  end

  @doc false
  def changeset(followers, attrs \\ %{}) do
    followers
    |> cast(attrs, [:href, :total])
  end
end
