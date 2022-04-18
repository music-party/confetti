defmodule ConfettiWeb.Schema.PartyTypes do
  @moduledoc """
  Party GraphQL types
  """
  use Absinthe.Schema.Notation

  object :party do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :description, non_null(:string)
    field :privacy, non_null(:privacy)
    field :host, non_null(:user)
    field :queue, non_null(list_of(non_null(:track)))
    field :tags, non_null(list_of(non_null(:tag)))
  end

  enum :privacy do
    value :public
    value :private
  end

  object :tag do
    field :name, non_null(:string)
    field :weight, non_null(:float)
  end

  object :track do
    field :id, non_null(:id)
    field :position, non_null(:integer)
  end
end
