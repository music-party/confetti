defmodule Confetti.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Confetti.Accounts` context.
  """

  @doc """
  Generate a unique user spotify_id.
  """
  def unique_user_spotify_id, do: "some spotify_id#{System.unique_integer([:positive])}"

  @doc """
  Generate a user.
  """
  def user_fixture(params \\ %{}) do
    {:ok, user} =
      params
      |> Enum.into(%{
        spotify_access_token: "some spotify_access_token",
        spotify_id: unique_user_spotify_id(),
        spotify_refresh_token: "some spotify_refresh_token"
      })
      |> Confetti.Accounts.create_user()

    user
  end
end
