defmodule ConfettiWeb.Schema.AccountsTypes do
  use Absinthe.Schema.Notation

  object :accounts_queries do
    @desc "Get a user using criteria"
    field :user, :user do

    end
  end

  @desc "A Music Party user"
  object :user do
    field :spotify_id, non_null(:string)
    field :current_party, :party
    field :role, non_null(:role)
  end

  enum :role do
    value :user
    value :admin
  end
end
