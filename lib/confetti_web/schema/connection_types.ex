defmodule ConfettiWeb.Schema.ConnectionTypes do
  @moduledoc """
  GraphQL Cursor Connection Types

  https://relay.dev/graphql/connections.htm
  """
  use Absinthe.Schema.Notation

  interface :connection do
    arg :first, :integer
    arg :after, non_null(:string)
    arg :last, :integer
    arg :before, non_null(:string)
    field :edges, list_of(:edge)
    field :page_info, non_null(:page_info)
  end

  interface :edge do
    field :node, :object
    field :cursor, non_null(:string)
  end

  object :page_info do
    field :has_previous_page, non_null(:boolean)
    field :has_next_page, non_null(:boolean)
    field :start_cursor, non_null(:string)
    field :end_cursor, non_null(:string)
  end
end
