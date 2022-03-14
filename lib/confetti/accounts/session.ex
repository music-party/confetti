defmodule Confetti.Accounts.Session do
  use Ecto.Schema
  import Ecto.Changeset

  alias Confetti.Accounts.User

  @required ~w(user access_token refresh_token expires_in)a
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime_usec]
  schema "sessions" do
    belongs_to :user, User
    field :access_token, :string
    field :refresh_token, :string
    field :expires_in, :integer, default: 3600
    timestamps(inserted_at: :created_at, updated_at: false)
  end

  @doc false
  def changeset(session, attrs) do
    session
    |> cast(attrs, [] ++ @required)
    |> validate_required(@required)
  end
end
