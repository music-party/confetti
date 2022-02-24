defmodule Confetti.Spotify.Auth do
  @base_url "https://accounts.spotify.com/authorize?"

  defp generate_random_string(length) do
    :crypto.strong_rand_bytes(length)
    |> Base.url_encode64()
    |> binary_part(0, length)
  end

  @doc """
  client_id
  response_type
  redirect_uri
  scope
  state
  show_dialog
  """
  defp create_authorization_url() do
  end
end
