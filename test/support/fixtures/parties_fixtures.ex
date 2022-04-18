defmodule Confetti.PartiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Confetti.Parties` context.
  """

  @doc """
  Generate a party.
  """
  def party_fixture(params \\ %{}) do
    {:ok, party} =
      params
      |> Enum.into(%{
        description: "some description",
        name: "some name",
        privacy: :public
      })
      |> Confetti.Parties.create_party()

    party
  end

  @doc """
  Generate a tag.
  """
  def tag_fixture(params \\ %{}) do
    {:ok, tag} =
      params
      |> Enum.into(%{
        name: "some name",
        weight: 120.5
      })
      |> Confetti.Parties.create_tag()

    tag
  end
end
