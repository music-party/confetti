defmodule ConfettiWeb.Schema do
  use Absinthe.Schema
  alias ConfettiWeb.Schema

  # import_types Absinthe.Type.Custom # imports :datetime type
  import_types Schema.AccountsTypes
  import_types Schema.ContentTypes

  query do
    # import_fields :accounts_queries
    # import_fields :content_queries
  end

  mutation do
    # import_fields :accounts_mutations
    # import_fields :content_mutations
  end

  subscription do

  end
end
