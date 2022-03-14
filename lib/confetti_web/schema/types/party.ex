defmodule ConfettiWeb.Schema.Types.Party do
  use ConfettiWeb.GraphQL, :type

  object :party do
    field :id, :id
    field :name, :string
  end
end
