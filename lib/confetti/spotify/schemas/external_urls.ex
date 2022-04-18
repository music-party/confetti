defmodule Confetti.Spotify.Schemas.ExternalUrls do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :spotify, :string
  end

  @doc false
  def changeset(external_urls, params \\ %{}) do
    external_urls
    |> cast(params, [:spotify])
  end
end
