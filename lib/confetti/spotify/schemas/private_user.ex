defmodule Confetti.Spotify.Schemas.PrivateUser do
  use Ecto.Schema
  import Ecto.Changeset

  alias Confetti.Spotify.Schemas

  @primary_key false
  embedded_schema do
    field :country, :string
    field :display_name, :string
    field :email, :string
    embeds_one :explicit_content, Schemas.ExplicitContent
    embeds_one :external_urls, Schemas.ExternalUrls
    embeds_one :followers, Schemas.Followers
    field :href, :string
    field :id, :string
    embeds_many :images, Schemas.Image
    field :product, :string
    field :type, :string
    field :uri, :string
  end

  def changeset(private_user, attrs \\ %{}) do
    private_user
    |> cast(attrs, [:country, :display_name, :email, :href, :id, :product, :type, :uri])
    |> cast_embed(:explicit_content, with: &Schemas.ExplicitContent.changeset/2)
    |> cast_embed(:external_urls, with: &Schemas.ExternalUrls.changeset/2)
    |> cast_embed(:followers, with: &Schemas.Followers.changeset/2)
    |> cast_embed(:images, with: &Schemas.Image.changeset/2)
    |> validate_inclusion(:product, ["free", "open", "premium"])
    |> validate_inclusion(:type, ["user"])
  end
end
