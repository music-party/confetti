defmodule ConfettiWeb.Schema.PartyTypes do
  @moduledoc """
  Party GraphQL types
  """
  use Absinthe.Schema.Notation

  alias ConfettiWeb.Resolvers

  object :party do
    field :description, non_null(:string)
    field :history, non_null(list_of(non_null(:string)))
    field :host, non_null(:user)
    field :id, non_null(:id)
    field :listeners, non_null(list_of(non_null(:user))) do
      interface :connection
    end
    field :moderators, non_null(list_of(non_null(:user)))
    field :name, non_null(:string)
    field :privacy, non_null(:privacy)
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

  object :party_queries do
    field :party, :party do
      arg :id, non_null(:id)
      resolve &Resolvers.Party.get_by/3
    end
  end
end
