defmodule ConfettiWeb.GraphQL do
  @moduledoc """
  A module that keeps using definitions for graphql components.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end

  def type do
    quote do
      use Absinthe.Schema.Notation
    end
  end

  def schema do
    quote do
      use Absinthe.Schema
    end
  end

  def resolver do
    quote do
      alias Confetti.Repo
    end
  end
end
