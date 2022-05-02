defmodule ConfettiWeb.AuthController do
  @moduledoc """
  Auth controller responsible for handling Ueberauth responses
  """
  use ConfettiWeb, :controller

  plug Ueberauth

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case User.find_or_create(auth) do
      {:ok, user} ->
        Logger.info("User authentication success:\n\t#{auth.uid}", ansi_color: :green)
        conn |> log_in(user)
      {:error, _error} ->
        Logger.info("User authentication succeeded:\n\t#{auth.uid}", ansi_color: :green)
        conn |> redirect(to: "/?error=authentication_error")
    end
  end

  def callback(%{assigns: %{ueberauth_failure: fails}} = conn, _params) do
    Logger.info("User authentication failure:\n\t#{fails}", ansi_color: :red)
    conn |> redirect(to: "/?callback=error")
  end

  def delete(conn, _params), do: log_out(conn)

  defp log_in(conn, user) do
    conn
    |> assign(:current_user, user)
    |> renew_session()
    |> put_session("id", user.id)
    |> redirect(to: "/?log-in=success")
  end

  defp log_out(conn) do
    conn
    |> renew_session()
    |> redirect(to: "/?log-out=success")
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
