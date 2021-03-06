defmodule Confetti.Spotify.Auth do
  @moduledoc """
  Authentication and authorization for the Spotify Web API.

  This module operates independently from the rest of the Spotify context.
  """
  alias Confetti.Spotify

  @base_url "https://accounts.spotify.com"

  @doc """
  Creates the url for the Authorization Code Flow
  """
  def url() do
    @base_url <>
      "/authorize?" <>
      URI.encode_query(%{
        client_id: Spotify.client_id(),
        redirect_uri: Spotify.redirect_uri(),
        response_type: "code",
        scope: Spotify.scope(),
        show_dialog: Spotify.show_dialog(),
        state: generate_random_string(16)
      })
  end


  def get_user_tokens(code) do
    data = Tesla.post(
             client(),
             "/api/token",
             %{code: code, grant_type: "authorization_code", redirect_uri: Spotify.redirect_uri()},
             headers: [
               {"Authorization", "Basic " <> :base64.encode("#{Spotify.client_id()}:#{Spotify.client_secret()}")}
             ]
           )
           |> handle_response()

    case data do
      %{"access_token" => access_token, "refresh_token" => refresh_token} -> {:ok, %{access_token: access_token, refresh_token: refresh_token}}
      %{"error" => %{"message" => error}} -> {:error, error}
      %{"error" => error} when is_binary(error) -> {:error, error}
      %{status: status} = env when status in 400..599 ->
        IO.inspect(env)
        {:error, "unknown_error"}
    end
  end

  defp client() do
    middleware = [
      {Tesla.Middleware.BaseUrl, @base_url},
      Tesla.Middleware.FormUrlencoded,
      Tesla.Middleware.DecodeJson
    ]

    adapter = {Tesla.Adapter.Hackney, [recv_timeout: 30_000]}
    Tesla.client(middleware, adapter)
  end

  defp handle_response({:ok, %Tesla.Env{} = env}) do
    case env do
      %{status: status, body: body} when status in 200..299 -> {:ok, body}
      %{body: body} -> {:error, body}
    end
  end

  defp generate_random_string(length) do
    :crypto.strong_rand_bytes(length)
    |> Base.url_encode64()
    |> binary_part(0, length)
  end
end
