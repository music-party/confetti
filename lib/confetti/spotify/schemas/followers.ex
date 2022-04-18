defmodule Confetti.Spotify.Schemas.Followers do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :href, :string
    field :total, :integer
  end

  @doc false
  def changeset(followers, params \\ %{}) do
    followers
    |> cast(params, [:href, :total])
  end
end
