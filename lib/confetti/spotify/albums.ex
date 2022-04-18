defmodule Confetti.Spotify.Albums do
  @doc ~S"""
  Get Spotify catalog information for a single album.

  ### Examples

      iex> Spotify.Albums.get_album("some album id")
      {:ok, %Spotify.Schemas.Album{}}

  """
  def get_album(_id, _market) do
    :not_implemented
  end
end
