defmodule Confetti.Identity do
  @moduledoc """
  User Identity Schema
  """
  use Confetti.Schema

  alias Confetti.User

  @primary_key {:id, :string, autogenerate: false}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime_usec]
  schema "identities" do
    field :country, :string
    field :display_name, :string
    field :email, :string

    embeds_one :explicit_content, ExplicitContent, primary_key: false, on_replace: :update do
      field :filter_enabled, :boolean
      field :filter_locked, :boolean
    end

    embeds_many :images, Image, primary_key: false, on_replace: :delete do
      field :height, :integer
      field :url, :string
      field :width, :integer
    end

    field :product, :string
    belongs_to :user, User
    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, [:country, :display_name, :email, :product])
    |> validate_required([:country, :display_name, :email, :product])
  end
end
