defmodule Confetti.User do
  @moduledoc """
  User Schema
  """
  use Confetti.Schema

  alias Confetti.{Identity, Party}

  defmodule Settings do
    @moduledoc """
    User Settings Schema
    """
    use Ecto.Schema

    @primary_key false
    embedded_schema do
      field :subscribe_to_dev_updates, :boolean, default: true
      field :subscribe_to_newsletter, :boolean, default: true
    end

    def changeset(settings, params \\ %{}) do
      cast(settings, params, __MODULE__.__schema__(:fields))
    end
  end

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime_usec]
  schema "users" do
    field :name, :string
    field :email, :string
    field :confirmed?, :boolean, default: false
    field :admin?, :boolean, default: false
    has_one :identity, Identity
    embeds_one :settings, Settings, on_replace: :update
    belongs_to :current_party, Party

    field :last_login, :utc_datetime_usec
    timestamps()
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:name, :email, :confirmed?, :admin?, :last_login])
  end

  def get(id), do: Repo.get(__MODULE__, id)
end
