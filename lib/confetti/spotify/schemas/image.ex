defmodule Confetti.Spotify.Schemas.Image do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :height, :integer
    field :url, :string
    field :width, :integer
  end

  def changeset(image, attrs \\ %{}) do
    image
    |> cast(attrs, [:height, :url, :width])
  end
end
