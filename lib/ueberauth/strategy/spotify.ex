defmodule Ueberauth.Strategy.Spotify do
  @moduledoc """
  Provides an Ueberauth strategy for authenticating with Spotify.

  ### Setup

  Create an application in Spotify for you to use.

  Register a new application at [your Spotify Developer Dashboard](https://developer.spotify.com/dashboard/applications)
  and get the `client_id` and `client_secret`.

  Include the provider in your configuration for Ueberauth;

      config :ueberauth, Ueberauth,
        providers: [
          spotify: { Ueberauth.Strategy.Spotify, [] }
        ]

  Then include the configuration for Spotify:

      config :ueberauth, Ueberauth.Strategy.Spotify.OAuth,
        client_id: System.get_env("SPOTIFY_CLIENT_ID"),
        client_secret: System.get_env("SPOTIFY_CLIENT_SECRET")

  If you haven't already, setup routes for your callback handler

      scope "/auth" do
        pipe_through [:browser]
        get "/:provider", AuthController, :request
        get "/:provider/callback", AuthController, :callback
      end

  Create an endpoint for the callback where you will handle the
  `Ueberauth.Auth` struct:

      defmodule MyApp.AuthController do
        use MyApp.Web, :controller

        plug Ueberauth

        def callback(%{ assigns: %{ ueberauth_auth: auth } } = conn, _params) do
          # do things with the auth
        end

        def callback(%{ assigns: %{ ueberauth_failure: fails } } = conn, _params) do
          # do things with the failure
        end
      end

  You can edit the behaviour of the Strategy by including some options when you
  register your provider.

  To set the `uid_field`:

      config :ueberauth, Ueberauth,
        providers: [
          spotify: { Ueberauth.Strategy.Spotify, [uid_field: :email] }
        ]

  Default is `:id`.

  To set the default 'scope' (permissions):

      config :ueberauth, Ueberauth,
        providers: [
          spotify: { Ueberauth.Strategy.Spotify, [default_scope: "user-read-email user-read-private"] }
        ]

  Default is empty ("") which only grants access to "publicly available
  information: that is, only information normally visible in the Spotify
  desktop, web, and mobile players."
  """
  use Ueberauth.Strategy,
    uid_field: :id,
    default_scope: "user-read-email user-read-private",
    oauth2_module: Ueberauth.Strategy.Spotify.OAuth

  alias Ueberauth.Auth.Credentials
  alias Ueberauth.Auth.Extra
  alias Ueberauth.Auth.Info

  @doc """
  Handles the initial redirect to the Spotify authentication page.

  To customize the scope (permissions) that are requested by Spotify, include
  them as part of your url:

      "/auth/spotify?scope=user-read-email%20user-read-private"
  """
  @impl Ueberauth.Strategy
  def handle_request!(conn) do
    params =
      []
      |> with_scope(conn)
      |> with_state_param(conn)
      |> with_redirect_uri(conn)

    module = option(conn, :oauth2_module)
    redirect!(conn, apply(module, :authorize_url!, [params]))
  end

  @doc """
  Handles the callback from Spotify.

  When there is a failure from Spotify, the failure is included in the
  `ueberauth_failure` struct. Otherwise the information returned from Spotify is
  returned in the `Ueberauth.Auth` struct.
  """
  @impl Ueberauth.Strategy
  def handle_callback!(%Plug.Conn{params: %{"code" => code}} = conn) do
    module = option(conn, :oauth2_module)
    token = apply(module, :get_token!, [[code: code]])

    if token.access_token == nil do
      set_errors!(conn, [
        error(token.other_params["error"], token.other_params["error_description"])
      ])
    else
      fetch_user(conn, token)
    end
  end

  def handle_callback!(conn) do
    set_errors!(conn, [error("missing_code", "No code received")])
  end

  @doc """
  Cleans up the private area of the connection used for passing the raw Spotify
  response around during the callback.
  """
  @impl Ueberauth.Strategy
  def handle_cleanup!(conn) do
    conn
    |> put_private(:spotify_user, nil)
    |> put_private(:spotify_token, nil)
  end

  @doc """
  Fetches the `:uid` field from the Spotify response.

  This defaults to the option `:uid_field` which in-turn defaults to `:id`
  """
  @impl Ueberauth.Strategy
  def uid(conn) do
    conn |> option(:uid_field) |> to_string() |> fetch_uid(conn)
  end

  @doc """
  Includes the credentials from the Spotify response.
  """
  @impl Ueberauth.Strategy
  def credentials(conn) do
    token = conn.private[:spotify_token]

    %Credentials{
      expires: not is_nil(token.expires_at),
      expires_at: token.expires_at,
      refresh_token: token.refresh_token,
      scopes: token.other_params["scope"] |> String.split(" "),
      token: token.access_token,
      token_type: token.token_type
    }
  end

  @doc """
  Fetches the fields to populate the info section of the `Ueberauth.Auth` struct.
  """
  @impl Ueberauth.Strategy
  def info(conn) do
    user = conn.private[:spotify_user]

    %Info{
      email: user["email"],
      image: fetch_image(user),
      name: user["display_name"],
      nickname: user["id"],
      urls: %{
        external_urls: user["external_urls"]
      }
    }
  end

  @doc """
  Stores the raw information (including the token) obtained from the Spotify
  callback.
  """
  @impl Ueberauth.Strategy
  def extra(conn) do
    %Extra{
      raw_info: %{
        token: conn.private[:spotify_token],
        user: conn.private[:spotify_user]
      }
    }
  end

  defp fetch_uid(field, conn), do: conn.private[:spotify_user][field]

  defp fetch_image(user) do
    user["images"]
    |> hd()
    |> Map.get("url")
  end

  defp fetch_user(conn, token) do
    conn = put_private(conn, :spotify_token, token)

    case Ueberauth.Strategy.Spotify.OAuth.get(token, "/me") do
      {:ok, %OAuth2.Response{status_code: status_code, body: user}}
      when status_code in 200..399 ->
        put_private(conn, :spotify_user, user)

      {:ok, %OAuth2.Response{status_code: 401, body: _body}} ->
        set_errors!(conn, [error("token", "unauthorized")])

      {:error, %OAuth2.Error{reason: reason}} ->
        set_errors!(conn, [error("OAuth2", reason)])

      {:error, %OAuth2.Response{body: %{"message" => reason}}} ->
        set_errors!(conn, [error("OAuth2", reason)])

      {:error, _} ->
        set_errors!(conn, [error("OAuth2", "uknown error")])
    end
  end

  defp option(conn, key) do
    Keyword.get(options(conn) || [], key, Keyword.get(default_options(), key))
  end

  defp with_scope(opts, conn) do
    scope = conn.params["scope"] || option(conn, :default_scope)

    opts |> Keyword.put(:scope, scope)
  end

  defp with_redirect_uri(opts, conn) do
    opts |> Keyword.put(:redirect_uri, callback_url(conn))
  end
end
