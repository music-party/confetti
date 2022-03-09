defmodule Confetti.Parties.Party do
  use Ecto.Schema
  import Ecto.Changeset

  alias Confetti.Accounts.User
  alias Confetti.Parties.Tag

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime_usec]
  schema "parties" do
    field :name, :string, null: false
    field :description, :string, default: ""
    field :privacy, Ecto.Enum, values: [:public, :private], default: :private
    belongs_to :host, User
    has_many :tags, Tag

    embeds_many :queue, Track, primary_key: false do
      embeds_one :album, Album, primary_key: false do
        field :id, :string, primary_key: true

        embeds_many :images, Image do
          field :height, :integer
          field :url, :string
          field :width, :integer
        end

        field :name, :string
        field :uri, :string
      end

      embeds_many :artists, Artist, primary_key: false do
        field :id, :string, primary_key: true
        field :name, :string
        field :uri, :string
      end

      field :available_markets, {:array, :string}
      field :duration_ms, :integer
      field :explicit, :boolean
      field :id, :string, primary_key: true
      field :index, :integer
      field :name, :string
      field :uri, :string
    end

    timestamps()
    field :deleted_at, :utc_datetime_usec, default: nil
  end

  @required ~w(name)a
  def changeset(party, attrs \\ %{}) do
    party
    |> cast(attrs, [:description, :privacy] ++ @required)
    |> cast_embed(:queue, with: &track_changeset/2)
    |> validate_required(@required)
  end

  @required ~w(duration_ms explicit id index name uri)a
  defp track_changeset(track, attrs) do
    track
    |> cast(attrs, [:available_markets] ++ @required)
    |> cast_embed(:album, with: &album_changeset/2)
    |> cast_embed(:artist, with: &artist_changeset/2)
    |> validate_required(@required)
  end

  @required ~w(id name uri)a
  defp artist_changeset(artist, attrs) do
    artist
    |> cast(attrs, @required)
    |> validate_required(@required)
  end

  @required ~w(id name uri)a
  defp album_changeset(album, attrs) do
    album
    |> cast(attrs, [] ++ @required)
    |> cast_embed(:images, with: &image_changeset/2)
    |> validate_required(@required)
  end

  @required ~w(url)a
  defp image_changeset(image, attrs) do
    image
    |> cast(attrs, [:height, :width] ++ @required)
    |> validate_required(@required)
  end
end
