defmodule Confetti.Spotify.Auth do
  @moduledoc """
  Authentication and authorization for the Spotify Web API.

  This module operates independently from the rest of the Spotify context.
  """
  import Confetti.Spotify.Config

  @base_url "https://accounts.spotify.com"

  @doc """
  Creates the url for the Authorization Code Flow
  """
  def url() do
    @base_url <>
      "/authorize?" <>
      URI.encode_query(%{
        client_id: client_id(),
        redirect_uri: redirect_uri(),
        response_type: "code",
        scope: scope(),
        show_dialog: show_dialog(),
        state: generate_random_string(16)
      })
  end

  def get_user_tokens(code) do
    with {:ok,
          %{
            status: 200,
            body: %{"access_token" => at, "refresh_token" => rt}
          }} <-
           Tesla.post(client(), "/api/token", %{
             code: code,
             grant_type: "authorization_code",
             redirect_uri: redirect_uri()
           }) do
      {:ok, %{access_token: at, refresh_token: rt}}
    else
      {:ok, %{body: %{"error" => error}}} -> {:error, error}
      _ -> {:error, "unknown_error"}
    end
  end

  defp handle_response({:ok, %Tesla.Env{} = env}) do
    case env do
      %{status: status, body: body} when status in 200..299 -> {:ok, body}
      %{body: body} -> {:error, body}
    end
  end

  defp client() do
    Tesla.client(
      [
        {Tesla.Middleware.BaseUrl, @base_url},
        Tesla.Middleware.FormUrlencoded,
        Tesla.Middleware.DecodeJson,
        {Tesla.Middleware.BasicAuth, username: client_id(), password: client_secret()}
      ],
      {Tesla.Adapter.Hackney, [recv_timeout: 30_000]}
    )
  end

  defp generate_random_string(length) do
    :crypto.strong_rand_bytes(length)
    |> Base.url_encode64()
    |> binary_part(0, length)
  end
end
