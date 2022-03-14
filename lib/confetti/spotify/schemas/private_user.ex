defmodule Confetti.Spotify.Schemas.PrivateUser do
  use Ecto.Schema
  import Ecto.Changeset

  alias Confetti.Spotify.Schemas, as: Spotify

  @required ~w(country email id product type)a
  @primary_key false
  embedded_schema do
    field :country, :string
    field :display_name, :string
    field :email, :string
    embeds_one :explicit_content, Spotify.ExplicitContent
    embeds_one :external_urls, Spotify.ExternalUrls
    embeds_one :followers, Spotify.Followers
    field :href, :string
    field :id, :string
    embeds_many :images, Spotify.Image
    field :product, :string
    field :type, :string
    field :uri, :string
  end

  @doc false
  def changeset(private_user, attrs \\ %{}) do
    private_user
    |> cast(attrs, [:display_name, :href, :uri] ++ @required)
    |> cast_embed(:explicit_content, with: &Spotify.ExplicitContent.changeset/2)
    |> cast_embed(:external_urls, with: &Spotify.ExternalUrls.changeset/2)
    |> cast_embed(:followers, with: &Spotify.Followers.changeset/2)
    |> cast_embed(:images, with: &Spotify.Image.changeset/2)
    |> validate_required(@required)
    |> validate_inclusion(:product, ["free", "open", "premium"])
    |> validate_inclusion(:type, ["user"])
  end
end
