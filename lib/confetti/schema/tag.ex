defmodule Confetti.Tag do
  @moduledoc """
  Metadata Tag Schema
  """
  use Confetti.Schema

  alias Confetti.Party

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tags" do
    field :name, :string
    field :weight, :float
    belongs_to :party, Party
  end

  def changeset(tag, params \\ %{}) do
    tag
    |> cast(params, [:name, :weight])
    |> validate_required([:name, :weight])
    |> update_change(:name, &String.downcase/1)
  end
end
