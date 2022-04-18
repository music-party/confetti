defmodule ConfettiWeb.AuthController do
  @moduledoc """
  Auth Controller
  """
  use ConfettiWeb, :controller

  def request(_conn, _params), do: :not_implemented

  def callback(_conn, _params), do: :not_implemented

  def delete(_conn, _params), do: :not_implemented
end
