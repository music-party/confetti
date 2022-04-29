defmodule Confetti.Party do
  @moduledoc """
  Party Schema
  """
  use Confetti.Schema

  alias Confetti.Message
  alias Confetti.Tag
  alias Confetti.User

  defmodule Track do
    @moduledoc """
    Party Track Schema
    """
    use Confetti.Schema

    @primary_key false
    embedded_schema do
      field :id, :string, primary_key: true
      field :position, :integer
    end

    def changeset(track, params \\ %{}) do
      track
      |> cast(params, [:id, :position])
      |> validate_required([:id, :position])
    end
  end

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime_usec]
  schema "parties" do
    field :name, :string
    field :description, :string, default: ""
    field :privacy, Ecto.Enum, values: [:public, :private], default: :private
    belongs_to :host, User
    has_many :listeners, User, foreign_key: :current_party_id
    embeds_many :queue, Track
    field :history, {:array, :string}
    has_many :tags, Tag
    has_many :messages, Message
    timestamps()
  end

  def changeset(party, params \\ %{}) do
    party
    |> cast(params, [:name, :description, :privacy])
    |> validate_required([:name, :description, :privacy])
    |> cast_assoc(:host, required: true)
  end

  def get(id), do: Repo.get(__MODULE__, id)
end
