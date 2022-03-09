defmodule Confetti.Spotify.Users do
  import Confetti.Spotify
  alias Confetti.Spotify.Schemas.{PrivateUser}

  def get_current_user(token) do
    with {:ok, res} <- Tesla.get(client(token), "/users/me"),
         %Ecto.Changeset{valid?: true} = cs <- PrivateUser.changeset(%PrivateUser{}, res.body) do
      {:ok, Ecto.Changeset.apply_changes(cs)}
    else
      {:error, res} -> {:error, res}
      %Ecto.Changeset{valid?: false} -> {:error, "API data does not match changeset"}
    end
  end
end
