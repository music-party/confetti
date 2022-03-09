defmodule Confetti.Spotify.Auth do
  @moduledoc """
  Authentication and authorization for the Spotify Web API
  """
  import Confetti.Spotify

  @base_url "https://accounts.spotify.com"

  @doc "creates url for the Authorization Code Flow"
  def url() do
    @base_url <>
      "/authorize?" <>
      URI.encode_query(%{
        client_id: client_id(),
        response_type: "code",
        redirect_uri: redirect_uri(),
        state: generate_random_string(16),
        scope: scope(),
        show_dialog: show_dialog()
      })
  end

  def get_user_tokens(code) do
    with %{body: %{"access_token" => access_token, "refresh_token" => refresh_token}} <-
           Tesla.post!(
             client(),
             "/api/token",
             %{grant_type: "authorization_code", code: code, redirect_uri: redirect_uri()},
             headers: [
               {"Authorization", "Basic " <> :base64.encode("#{client_id()}:#{client_secret()}")}
             ]
           ) do
      {:ok, %{access_token: access_token, refresh_token: refresh_token}}
    else
      %{body: body} -> {:error, body}
    end
  end

  defp client() do
    middleware = [
      {Tesla.Middleware.BaseUrl, @base_url},
      Tesla.Middleware.JSON,
      Tesla.Middleware.FormUrlencoded
    ]

    adapter = {Tesla.Adapter.Hackney, [recv_timeout: 30_000]}
    Tesla.client(middleware, adapter)
  end

  defp generate_random_string(length) do
    :crypto.strong_rand_bytes(length)
    |> Base.url_encode64()
    |> binary_part(0, length)
  end
end
