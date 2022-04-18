defmodule Confetti.Spotify.Client do
  @moduledoc "Module for making Spotify Web API requests"

  def get(token, url, opts \\ []), do: fetch(token, :get, url, opts)
  def post(token, url, opts \\ []), do: fetch(token, :post, url, opts)
  def put(token, url, opts \\ []), do: fetch(token, :put, url, opts)
  def delete(token, url, opts \\ []), do: fetch(token, :delete, url, opts)

  def handle_response(data, module) do
    with %{valid?: true} = cs <- apply(module, :changeset, [struct(module), data]) do
      {:ok, Ecto.Changeset.apply_changes(cs)}
    else
      _ -> :error
    end
  end

  defp fetch(token, method, url, opts) do
    with {:ok, %{status: status, body: body}} when status in 200..399 <-
           Tesla.request(client(token), [method: method, url: url] ++ opts) do
      {:ok, body}
    else
      {:ok, %{body: body}} -> {:error, body}
      {:error, _} = error -> error
    end
  end

  defp client(%{access_token: token}), do: client(token)

  defp client(token) when is_binary(token) do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://api.spotify.com/v1"},
      {Tesla.Middleware.BearerAuth, token: token},
      Tesla.Middleware.JSON
    ]

    adapter = {Tesla.Adapter.Hackney, [recv_timeout: 30_000]}
    Tesla.client(middleware, adapter)
  end
end
