defmodule Confetti.Message do
  @moduledoc """
  Party Message Schema
  """
  use Confetti.Schema

  alias Confetti.Party
  alias Confetti.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime_usec]
  schema "messages" do
    belongs_to :party, Party
    belongs_to :author, User
    field :content, :string
    timestamps()
  end

  def changeset(message, params \\ %{}) do
    message
    |> cast(params, [:content])
    |> cast_assoc(:party, required: true)
    |> cast_assoc(:user, required: true)
    |> validate_required([:content])
  end
end
