defmodule Confetti.Spotify do
  # Spotify constants
  def client_id, do: Application.get_env(:confetti, :spotify_client_id)
  def client_secret, do: Application.get_env(:confetti, :spotify_client_secret)
  def redirect_uri, do: Application.get_env(:confetti, :spotify_redirect_uri)
  def scope, do: Application.get_env(:confetti, :spotify_scope) |> Enum.join(" ")
  def show_dialog, do: Application.get_env(:confetti, :spotify_show_dialog)

  def handle_response({:ok, %Tesla.Env{} = env}) do
    case env do
      %{status: 204} -> :ok
      %{status: status, body: body} when status in 200..299 -> {:ok, body}
      %{body: %{"error" => %{"message" => error}}} -> {:error, error}
      %{body: body} -> {:error, body}
    end
  end
  def handle_response(error), do: error

  # Tesla client
  def client(token) do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://api.spotify.com/v1"},
      {Tesla.Middleware.BearerAuth, token: token},
      Tesla.Middleware.JSON
    ]
    adapter = {Tesla.Adapter.Hackney, [recv_timeout: 30_000]}
    Tesla.client(middleware, adapter)
  end
end
