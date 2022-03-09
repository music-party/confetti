defmodule Confetti.Spotify.Middleware.HandleResponse do
  @moduledoc """
  Return :ok/:error tuples for "success" responses
  """
  @behaviour Tesla.Middleware

  def call(env, next, _opts) do
    env
    # do something with request
    |> Tesla.run(next)
    # do something with response
    |> handle_response()
  end

  defp handle_response(env) do
    case env do
      %{status: 204} -> :ok
      %{status: status, body: body} when status in 200..299 -> {:ok, body}
      %{body: %{"error" => %{"message" => error}}} -> {:error, error}
    end
  end
end
