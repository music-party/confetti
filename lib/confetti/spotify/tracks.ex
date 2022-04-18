defmodule Confetti.Spotify.Tracks do
  @moduledoc """
  Tracks Endpoints

  - Get Track
  - Get Several Tracks
  - Get User's Saved Tracks
  - Save Tracks for Current User
  - Remove Tracks for Current User
  - Check User's Saved Tracks
  - Get Track's Audio Features
  - Get Tracks' Audio Features
  - Get Track's Audio Analysis
  - Get Recommendations
  """

  @doc """
  Get Spotify catalog information for a single track identified by its unique Spotify ID.
  """
  def get_track(_id, _market \\ nil) do
    :not_implemented
  end

  @doc """
  Get Spotify catalog information for multiple tracks based on their Spotify IDs.
  """
  def get_tracks(_ids, _market \\ nil) do
    :not_implemented
  end
end
