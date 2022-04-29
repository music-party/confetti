defmodule ConfettiWeb.AccountController do
  use ConfettiWeb, :controller

  alias Confetti.Spotify

  @spotify_auth_state "spotify_auth_state"

  @doc "returns a spotify login url and auth state"
  def login(conn, _params) do
    uri = URI.new!(Spotify.Auth.url())
    state = URI.decode_query(uri.query)["state"]
    json(conn, %{url: URI.to_string(uri), state: state})
  end

  @doc """
  1. check that the auth state matches and clear the cookie
  2. exchange code for user tokens
  3. fetch spotify user profile and verify premium
  4. save user's session and redirect
  """
  def callback(conn, %{"code" => code, "state" => state}) do
    # conn = verify_auth_state(conn, state)

    with {:ok, %{access_token: token}} <- Spotify.Auth.get_user_tokens(code),
         {:ok, %{product: "premium"} = user} <- Spotify.Users.get_current_user(token) do
      # save user session
      IO.inspect(user)
    else
      {:error, error} when is_binary(error) -> redirect_to_app(conn, "/?error=#{error}")
    end

    # redirect user
    redirect_to_app(conn, "dashboard")
  end

  defp verify_auth_state(conn, state) do
    conn = conn |> fetch_cookies()

    case conn.req_cookies[@spotify_auth_state] do
      ^state ->
        conn
        |> delete_resp_cookie(@spotify_auth_state)

      _ ->
        conn
        |> redirect_to_app("?error=state_mismatch")
    end
  end

  defp redirect_to_app(conn, path) when is_binary(path) do
    conn
    |> redirect(external: Application.get_env(:confetti, :app_url) <> path)
    |> halt()
  end
end
