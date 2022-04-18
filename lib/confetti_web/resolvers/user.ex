defmodule ConfettiWeb.Resolvers.User do
  @moduledoc """
  GraphQL User Resolvers
  """

  alias Confetti.User

  def get_by(_parent, %{id: id}, _resolution), do: {:ok, User.get(id)}

  def get_by(_parent, %{email: email}, _resolution), do: {:ok, :not_implemented}
end
