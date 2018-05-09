defmodule Hello.UsersTest do
  use Hello.DataCase

  alias Hello.Users

  describe "users" do
    alias Hello.Users.User

    @valid_attrs %{email: "some email", first_name: "some first_name", last_name: "some last_name", linked_in_profile_id: "some linked_in_profile_id", oauth_linked_in_token: "some oauth_linked_in_token", password_hash: "some password_hash", password_reset_at: ~N[2010-04-17 14:00:00.000000], password_reset_hash: "some password_reset_hash", system_role: "some system_role"}
    @update_attrs %{email: "some updated email", first_name: "some updated first_name", last_name: "some updated last_name", linked_in_profile_id: "some updated linked_in_profile_id", oauth_linked_in_token: "some updated oauth_linked_in_token", password_hash: "some updated password_hash", password_reset_at: ~N[2011-05-18 15:01:01.000000], password_reset_hash: "some updated password_reset_hash", system_role: "some updated system_role"}
    @invalid_attrs %{email: nil, first_name: nil, last_name: nil, linked_in_profile_id: nil, oauth_linked_in_token: nil, password_hash: nil, password_reset_at: nil, password_reset_hash: nil, system_role: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Users.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Users.list_users() == [user]
    end
test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Users.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.first_name == "some first_name"
      assert user.last_name == "some last_name"
      assert user.linked_in_profile_id == "some linked_in_profile_id"
      assert user.oauth_linked_in_token == "some oauth_linked_in_token"
      assert user.password_hash == "some password_hash"
      assert user.password_reset_at == ~N[2010-04-17 14:00:00.000000]
      assert user.password_reset_hash == "some password_reset_hash"
      assert user.system_role == "some system_role"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Users.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "some updated email"
      assert user.first_name == "some updated first_name"
      assert user.last_name == "some updated last_name"
      assert user.linked_in_profile_id == "some updated linked_in_profile_id"
      assert user.oauth_linked_in_token == "some updated oauth_linked_in_token"
      assert user.password_hash == "some updated password_hash"
      assert user.password_reset_at == ~N[2011-05-18 15:01:01.000000]
      assert user.password_reset_hash == "some updated password_reset_hash"
      assert user.system_role == "some updated system_role"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_attrs)
      assert user == Users.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Users.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Users.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Users.change_user(user)
    end
  end
end
