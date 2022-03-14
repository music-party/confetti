defmodule Confetti.Spotify.Schemas.ExplicitContent do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :filter_enabled, :boolean
    field :filter_locked, :boolean
  end

  @doc false
  def changeset(explicit_content, attrs \\ %{}) do
    explicit_content
    |> cast(attrs, [:filter_enabled, :filter_locked])
  end
end
