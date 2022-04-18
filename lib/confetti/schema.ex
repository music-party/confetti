defmodule Confetti.Schema do
  @moduledoc """
  Entrypoint for defining schemas
  """
  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema

      import Ecto
      import Ecto.Changeset
      import Ecto.Query, only: [from: 1, from: 2]

      alias Confetti.Repo
    end
  end
end
