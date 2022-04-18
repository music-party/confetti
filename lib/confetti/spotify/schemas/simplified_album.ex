defmodule Confetti.Spotify.Schemas.SimplifiedAlbum do
  use Ecto.Schema
  import Ecto.Changeset

  alias Confetti.Spotify.Schemas, as: Spotify

  @required ~w(id name uri)a
  @primary_key false
  embedded_schema do
    field :album_type, :string
    field :total_tracks, :integer
    field :available_markets, {:array, :string}
    embeds_one :external_urls, Spotify.ExternalUrls
    field :href, :string
    field :id, :string, primary_key: true
    embeds_many :images, Spotify.Image
    field :name, :string
    field :release_date, :string
    field :release_date_precision, :string
    embeds_one :restrictions, Spotify.Restriction
    field :type, :string
    field :uri, :string
    field :album_group, :string
    embeds_many :artists, Spotify.Artist
  end

  @doc false
  def changeset(album, params \\ %{}) do
    album
    |> cast(params, [] ++ @required)
    |> cast_embed(:external_urls, with: &Spotify.ExternalUrls.changeset/2)
    |> cast_embed(:images, with: &Spotify.Image.changeset/2)
    |> validate_required(@required)
    |> validate_inclusion(:album_type, ["album", "single", "compilation"])
    |> validate_inclusion(:release_date_precision, ["year", "month", "day"])
    |> validate_inclusion(:album_group, ["album", "single", "compilation", "appears_on"])
  end
end
