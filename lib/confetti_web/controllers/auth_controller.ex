defmodule ConfettiWeb.AuthController do
  @moduledoc """
  Auth controller responsible for handling Ueberauth responses
  """
  use ConfettiWeb, :controller

  alias Confetti.User

  plug Ueberauth

  @app_url Application.fetch_env!(:confetti, :app_url)

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case User.find_or_create(auth) do
      {:ok, user} ->
        Logger.info("User authentication success:\n\t#{auth.uid}")
        conn |> log_in(user)
      {:error, error} ->
        Logger.warn("User authentication failed:\n\t#{inspect(error)}")
        conn |> redirect(external: @app_url <> "/?error=authentication_error")
    end
  end

  def callback(%{assigns: %{ueberauth_failure: fails}} = conn, _params) do
    Logger.warn("User authentication failure:\n\t#{inspect(fails)}")
    conn |> redirect(external: @app_url <> "/?callback=error")
  end

  def delete(conn, _params), do: log_out(conn)

  defp log_in(conn, user) do
    conn
    |> assign(:current_user, user)
    |> renew_session()
    |> put_session("id", user.id)
    |> redirect(external: @app_url <> "/home")
  end

  defp log_out(conn) do
    conn
    |> renew_session()
    |> redirect(external: @app_url <> "/?log-out=success")
  end

  defp renew_session(conn) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
  end

  def require_user(conn, _opts) do
    if get_session(conn, :id) do
      conn
    else
      conn
      |> redirect(to: "/")
    end
  end
end
