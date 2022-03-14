defmodule Confetti.Content.Party do
  use Ecto.Schema
  import Ecto.Changeset

  alias Confetti.Accounts.User
  alias Confetti.Content.Tag

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
    embeds_many :queue, Track, primary_key: false do
      field :id, :string, primary_key: true
      field :index, :integer
    end

    timestamps()
    field :deleted_at, :utc_datetime_usec, default: nil
  end

  @doc false
  def changeset(party, attrs \\ %{}) do
    party
    |> cast(attrs, [:description, :privacy] ++ @required)
    |> cast_embed(:queue, with: &track_changeset/2)
    |> validate_required(@required)
  end

  @doc false
  defp track_changeset(track, attrs) do
    track
    |> cast(attrs, [:id, :index])
    |> validate_required([:id, :index])
  end
end
