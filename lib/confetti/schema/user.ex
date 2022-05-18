defmodule Confetti.User do
  @moduledoc """
  User Schema
  """
  use Confetti.Schema

  alias Confetti.Identity
  alias Confetti.Party

  defmodule Settings do
    @moduledoc """
    User Settings Schema
    """
    use Ecto.Schema

    @primary_key false
    embedded_schema do
      field :show_hints, :boolean, default: true
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
    |> cast_assoc(:identity, required: true, with: &Identity.changeset/2)
    |> cast_embed(:settings, required: true, with: &Settings.changeset/2)
    |> validate_required([:name, :email, :confirmed?, :admin?, :last_login])
  end

  def get(id), do: Repo.get(__MODULE__, id)

  def get_by_spotify_id(id) do
    Repo.one(
      from u in __MODULE__,
        join: i in assoc(u, :identity),
        where: i.id == ^id
    )
  end

  def find_or_create(%Ueberauth.Auth{} = auth) do
    if user = get_by_spotify_id(auth.uid) do
      {:ok, user}
    else
      %__MODULE__{last_login: DateTime.utc_now(), settings: %{}}
      |> changeset(
          Map.from_struct(auth.info)
          |> Map.merge(%{identity: auth.extra.raw_info.user})
        )
      |> Repo.insert()
    end
  end
end
