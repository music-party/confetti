defmodule Confetti.Spotify do
  @moduledoc """
  A context for the Spotify Web API
  """
  alias Confetti.Spotify.Tracks
  alias Confetti.Spotify.Users

  # ALBUMS
  # ARTISTS
  # SHOWS
  # EPISODES
  # TRACKS
  defdelegate get_track(token, id, market \\ nil), to: Tracks
  defdelegate get_tracks(token, ids, market \\ nil), to: Tracks
  # SEARCH
  # USERS
  defdelegate get_current_user(token), to: Users
  defdelegate get_user(token, id), to: Users
  # PLAYLISTS
  # GENRES
  # PLAYER
  # MARKETS
end
