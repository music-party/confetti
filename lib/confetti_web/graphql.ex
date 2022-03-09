defmodule ConfettiWeb.GraphQL do
  @moduledoc """
  A module that keeps using definitions for graphql components.
  """

  def type do
    quote do
      use Absinthe.Schema.Notation
      use Absinthe.Ecto, repo: Confetti.Repo
    end
  end

  def query do
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

  @doc """
  When used, dispatch to the appropriate type/query/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
