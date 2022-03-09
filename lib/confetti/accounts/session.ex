defmodule Confetti.Accounts.Session do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime_usec]
  schema "sessions" do
    has_one :user, User
    field :expires_in, :integer, default: 3600
    timestamps(inserted_at: :created_at, updated_at: false)
  end

  @doc false
  def changeset(session, attrs) do
    session
    |> cast(attrs, [:user, :expires_in])
    |> validate_required([:user, :expires_in])
  end
end
