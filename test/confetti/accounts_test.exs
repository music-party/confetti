defmodule Confetti.AccountsTest do
  use Confetti.DataCase

  alias Confetti.Accounts

  describe "users" do
    alias Confetti.Accounts.User

    import Confetti.AccountsFixtures

    @invalid_attrs %{spotify_id: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{spotify_id: "some spotify_id"}

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.spotify_id == "some spotify_id"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{spotify_id: "some updated spotify_id"}

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.spotify_id == "some updated spotify_id"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "users" do
    alias Confetti.Accounts.User

    import Confetti.AccountsFixtures

    @invalid_attrs %{spotify_access_token: nil, spotify_id: nil, spotify_refresh_token: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{
        spotify_access_token: "some spotify_access_token",
        spotify_id: "some spotify_id",
        spotify_refresh_token: "some spotify_refresh_token"
      }

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.spotify_access_token == "some spotify_access_token"
      assert user.spotify_id == "some spotify_id"
      assert user.spotify_refresh_token == "some spotify_refresh_token"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()

      update_attrs = %{
        spotify_access_token: "some updated spotify_access_token",
        spotify_id: "some updated spotify_id",
        spotify_refresh_token: "some updated spotify_refresh_token"
      }

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.spotify_access_token == "some updated spotify_access_token"
      assert user.spotify_id == "some updated spotify_id"
      assert user.spotify_refresh_token == "some updated spotify_refresh_token"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
