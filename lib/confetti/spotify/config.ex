defmodule Confetti.Spotify.Config do
  def client_id, do: Application.get_env(:confetti, :spotify_client_id)
  def client_secret, do: Application.get_env(:confetti, :spotify_client_secret)
  def redirect_uri, do: Application.get_env(:confetti, :spotify_redirect_uri)
  def scope, do: Application.get_env(:confetti, :spotify_scope) |> Enum.join(" ")
  def show_dialog, do: Application.get_env(:confetti, :spotify_show_dialog)
end
