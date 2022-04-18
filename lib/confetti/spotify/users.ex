defmodule Confetti.Spotify.Users do
  import Confetti.Spotify.Client
  alias Confetti.Spotify.Schemas.{PrivateUser}

  @doc """
  Get detailed profile information about the current user (including the current user's username).
  """
  def get_current_user(token) do
    get(token, "/me")
    |> handle_response(PrivateUser)
  end

  def get_user(_token, _id) do
    :not_implemented
  end
end
