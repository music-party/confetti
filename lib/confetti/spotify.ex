defmodule Confetti.Spotify do
  def client_id, do: Application.get_env(:spotify, :client_id)
  def client_secret, do: Application.get_env(:spotify, :client_secret)
  def redirect_uri, do: Application.get_env(:spotify, :redirect_uri)
  def scope, do: Application.get_env(:spotify, :scope)
end
