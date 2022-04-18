defmodule ConfettiWeb.Schema do
  @moduledoc """
  GraphQL Schema
  """
  use Absinthe.Schema

  alias ConfettiWeb.Schema

  import_types(Absinthe.Type.Custom)
  import_types(Schema.UserTypes)
  import_types(Schema.PartyTypes)

  query do
    # import_fields(:user_queries)
    # import_fields(:party_queries)
    field :user, :user do
      arg :id, non_null(:id)
      resolve fn %{id: user_id}, _ ->
        {:ok, %{id: user_id}}
      end
    end
  end

  # mutation do
    # import_fields :user_mutations
    # import_fields :party_mutations
  # end

  # subscription do
  # end
end
