defmodule ConfettiWeb.Schema.UserTypes do
  @moduledoc """
  GraphQL User Types
  """
  use Absinthe.Schema.Notation

  alias ConfettiWeb.Resolvers

  object :user do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :email, non_null(:string)
    field :confirmed, non_null(:boolean)
    field :admin, non_null(:boolean)
    field :current_party, :party
    field :last_login, :datetime
    field :settings, non_null(:settings)
  end

  object :settings do
    field :subscribe_to_dev_updates, non_null(:boolean)
    field :subscribe_to_newsletter, non_null(:boolean)
  end

  object :user_queries do
    field :user, :user do
      arg :id, non_null(:id)
      resolve &Resolvers.User.get_by/3
    end
  end
end
