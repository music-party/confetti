defmodule Confetti.PartiesTest do
  use Confetti.DataCase

  alias Confetti.Parties

  describe "parties" do
    alias Confetti.Parties.Party

    import Confetti.PartiesFixtures

    @invalid_params %{description: nil, name: nil, privacy: nil}

    test "list_parties/0 returns all parties" do
      party = party_fixture()
      assert Parties.list_parties() == [party]
    end

    test "get_party!/1 returns the party with given id" do
      party = party_fixture()
      assert Parties.get_party!(party.id) == party
    end

    test "create_party/1 with valid data creates a party" do
      valid_params = %{description: "some description", name: "some name", privacy: :public}

      assert {:ok, %Party{} = party} = Parties.create_party(valid_params)
      assert party.description == "some description"
      assert party.name == "some name"
      assert party.privacy == :public
    end

    test "create_party/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Parties.create_party(@invalid_params)
    end

    test "update_party/2 with valid data updates the party" do
      party = party_fixture()

      update_params = %{
        description: "some updated description",
        name: "some updated name",
        privacy: :private
      }

      assert {:ok, %Party{} = party} = Parties.update_party(party, update_params)
      assert party.description == "some updated description"
      assert party.name == "some updated name"
      assert party.privacy == :private
    end

    test "update_party/2 with invalid data returns error changeset" do
      party = party_fixture()
      assert {:error, %Ecto.Changeset{}} = Parties.update_party(party, @invalid_params)
      assert party == Parties.get_party!(party.id)
    end

    test "delete_party/1 deletes the party" do
      party = party_fixture()
      assert {:ok, %Party{}} = Parties.delete_party(party)
      assert_raise Ecto.NoResultsError, fn -> Parties.get_party!(party.id) end
    end

    test "change_party/1 returns a party changeset" do
      party = party_fixture()
      assert %Ecto.Changeset{} = Parties.change_party(party)
    end
  end

  describe "tags" do
    alias Confetti.Parties.Tag

    import Confetti.PartiesFixtures

    @invalid_params %{name: nil, weight: nil}

    test "list_tags/0 returns all tags" do
      tag = tag_fixture()
      assert Parties.list_tags() == [tag]
    end

    test "get_tag!/1 returns the tag with given id" do
      tag = tag_fixture()
      assert Parties.get_tag!(tag.id) == tag
    end

    test "create_tag/1 with valid data creates a tag" do
      valid_params = %{name: "some name", weight: 120.5}

      assert {:ok, %Tag{} = tag} = Parties.create_tag(valid_params)
      assert tag.name == "some name"
      assert tag.weight == 120.5
    end

    test "create_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Parties.create_tag(@invalid_params)
    end

    test "update_tag/2 with valid data updates the tag" do
      tag = tag_fixture()
      update_params = %{name: "some updated name", weight: 456.7}

      assert {:ok, %Tag{} = tag} = Parties.update_tag(tag, update_params)
      assert tag.name == "some updated name"
      assert tag.weight == 456.7
    end

    test "update_tag/2 with invalid data returns error changeset" do
      tag = tag_fixture()
      assert {:error, %Ecto.Changeset{}} = Parties.update_tag(tag, @invalid_params)
      assert tag == Parties.get_tag!(tag.id)
    end

    test "delete_tag/1 deletes the tag" do
      tag = tag_fixture()
      assert {:ok, %Tag{}} = Parties.delete_tag(tag)
      assert_raise Ecto.NoResultsError, fn -> Parties.get_tag!(tag.id) end
    end

    test "change_tag/1 returns a tag changeset" do
      tag = tag_fixture()
      assert %Ecto.Changeset{} = Parties.change_tag(tag)
    end
  end
end
