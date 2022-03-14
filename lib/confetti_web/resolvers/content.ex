defmodule ConfettiWeb.Resolvers.Content do
  def get_party(_parent, _args, _resolution) do
    {:ok, Confetti.Content.get_party()}
  end
end
