defmodule Confetti.Spotify.Schemas.Album do
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
    embeds_one :restrictions, Restriction do
      field :reason, :string
    end
    field :type, :string
    field :uri, :string
    embeds_many :artists
    embeds_one :tracks
    field :popularity
    field :label
    embeds_one :external_ids
  end

  @doc false
  def changeset(album, attrs \\ %{}) do
    album
    |> cast(attrs, [] ++ @required)
    |> cast_embed(:images, with: &Spotify.Image.changeset/2)
    |> validate_required(@required)
  end
end
