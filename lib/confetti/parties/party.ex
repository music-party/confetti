defmodule Confetti.Parties.Party do
  use Ecto.Schema
  import Ecto.Changeset

  alias Confetti.Spotify.Schemas, as: Spotify
  alias Confetti.Accounts.User
  alias Confetti.Parties.Tag

  @required ~w(name)a
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime_usec]
  schema "parties" do
    field :name, :string, null: false
    field :description, :string, default: ""
    field :privacy, Ecto.Enum, values: [:public, :private], default: :private
    belongs_to :host, User
    has_many :tags, Tag
    embeds_many :queue, Spotify.Track

    timestamps()
    field :deleted_at, :utc_datetime_usec, default: nil
  end

  @doc false
  def changeset(party, attrs \\ %{}) do
    party
    |> cast(attrs, [:description, :privacy] ++ @required)
    |> cast_embed(:queue, with: &Spotify.Track.changeset/2)
    |> validate_required(@required)
  end
end
