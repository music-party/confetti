defmodule Confetti.Spotify.Schemas.Track do
  use Ecto.Schema
  import Ecto.Changeset

  alias Confetti.Spotify.Schemas, as: Spotify

  @primary_key false
  embedded_schema do
    embeds_one :album, Spotify.Album
    embeds_many :artists, Spotify.Artist
    field :available_markets, {:array, :string}
    field :duration_ms, :integer
    field :explicit, :boolean
    field :id, :string, primary_key: true
    field :index, :integer
    field :name, :string
    field :uri, :string
  end

  @required ~w(duration_ms explicit id index name uri)a
  def changeset(track, params \\ %{}) do
    track
    |> cast(params, [:available_markets] ++ @required)
    |> cast_embed(:album, with: &Spotify.Album.changeset/2)
    |> cast_embed(:artist, with: &Spotify.Artist.changeset/2)
    |> validate_required(@required)
  end
end
