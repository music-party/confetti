defmodule ConfettiWeb.Resolvers.Party do
  @moduledoc """
  GraphQL Party Resolvers
  """

  alias Confetti.Party

  def get_by(_parent, %{id: id}, _resolution), do: {:ok, Party.get(id)}
end
