defmodule Confetti.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime_usec]
  schema "users" do
    field :spotify_id, :string
    field :spotify_access_token, :string
    field :spotify_refresh_token, :string
    field :current_party, :binary_id

    timestamps()
    field :deleted_at, :utc_datetime_usec, default: nil
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:spotify_id, :spotify_access_token, :spotify_refresh_token])
    |> validate_required([:spotify_id, :spotify_access_token, :spotify_refresh_token])
    |> unique_constraint(:spotify_id)
  end
end
