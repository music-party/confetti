defmodule Confetti.Spotify do
  # Spotify constants
  def client_id, do: Application.get_env(:confetti, :spotify_client_id)
  def client_secret, do: Application.get_env(:confetti, :spotify_client_secret)
  def redirect_uri, do: Application.get_env(:confetti, :spotify_redirect_uri)
  def scope, do: Application.get_env(:confetti, :spotify_scope) |> Enum.join(" ")
  def show_dialog, do: Application.get_env(:confetti, :spotify_show_dialog)

  # Tesla client
  def client(access_token) do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://api.spotify.com/v1"},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.BearerAuth, token: access_token},
      Confetti.Spotify.Middleware.HandleResponse
    ]
    adapter = {Tesla.Adapter.Hackney, [recv_timeout: 30_000]}
    Tesla.client(middleware, adapter)
  end
end
