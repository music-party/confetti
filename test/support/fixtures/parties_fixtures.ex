defmodule Confetti.PartiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Confetti.Parties` context.
  """

  @doc """
  Generate a party.
  """
  def party_fixture(attrs \\ %{}) do
    {:ok, party} =
      attrs
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
  def tag_fixture(attrs \\ %{}) do
    {:ok, tag} =
      attrs
      |> Enum.into(%{
        name: "some name",
        weight: 120.5
      })
      |> Confetti.Parties.create_tag()

    tag
  end
end
