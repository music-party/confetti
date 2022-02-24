defmodule Confetti.Accounts.Session do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime_usec, updated_at: false]
  schema "sessions" do
    has_one :user, User
    field :expired_at, :utc_datetime_usec
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:spotify_id, :spotify_access_token, :spotify_refresh_token])
    |> validate_required([:spotify_id, :spotify_access_token, :spotify_refresh_token])
    |> unique_constraint(:spotify_id)
  end
end
