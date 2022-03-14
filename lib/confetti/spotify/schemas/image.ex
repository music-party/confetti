defmodule Confetti.Spotify.Schemas.Image do
  use Ecto.Schema
  import Ecto.Changeset

  @required ~w(url)a
  embedded_schema do
    field :height, :integer
    field :url, :string
    field :width, :integer
  end

  @doc false
  def changeset(image, attrs \\ %{}) do
    image
    |> cast(attrs, [:height, :width] ++ @required)
    |> validate_required(@required)
  end
end
