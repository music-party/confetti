defmodule Confetti.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Confetti.Parties.Party

  @required ~w(spotify_id)a
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime_usec]
  schema "users" do
    field :spotify_id, :string
    field :spotify_access_token, :string
    field :spotify_refresh_token, :string
    belongs_to :current_party, Party
    field :type, Ecto.Enum, values: [:user, :admin], default: :user

    timestamps()
    field :deleted_at, :utc_datetime_usec, default: nil
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [] ++ @required)
    |> validate_required(@required)
    |> unique_constraint(:spotify_id)
  end
end
