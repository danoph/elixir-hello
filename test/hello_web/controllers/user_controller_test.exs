defmodule HelloWeb.UserControllerTest do
  use HelloWeb.ConnCase

  alias Hello.Users
  alias Hello.Users.User

  @create_attrs %{email: "some email", first_name: "some first_name", last_name: "some last_name", linked_in_profile_id: "some linked_in_profile_id", oauth_linked_in_token: "some oauth_linked_in_token", password_hash: "some password_hash", password_reset_at: ~N[2010-04-17 14:00:00.000000], password_reset_hash: "some password_reset_hash", system_role: "some system_role"}
  @update_attrs %{email: "some updated email", first_name: "some updated first_name", last_name: "some updated last_name", linked_in_profile_id: "some updated linked_in_profile_id", oauth_linked_in_token: "some updated oauth_linked_in_token", password_hash: "some updated password_hash", password_reset_at: ~N[2011-05-18 15:01:01.000000], password_reset_hash: "some updated password_reset_hash", system_role: "some updated system_role"}
  @invalid_attrs %{email: nil, first_name: nil, last_name: nil, linked_in_profile_id: nil, oauth_linked_in_token: nil, password_hash: nil, password_reset_at: nil, password_reset_hash: nil, system_role: nil}

  def fixture(:user) do
    {:ok, user} = Users.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get conn, user_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, user_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "email" => "some email",
        "first_name" => "some first_name",
        "last_name" => "some last_name",
        "linked_in_profile_id" => "some linked_in_profile_id",
        "oauth_linked_in_token" => "some oauth_linked_in_token",
        "password_hash" => "some password_hash",
        #"password_reset_at" => ~N[2010-04-17 14:00:00.000000],
        "password_reset_at" => "2010-04-17T14:00:00.000000",
        "password_reset_hash" => "some password_reset_hash",
        "system_role" => "some system_role"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put conn, user_path(conn, :update, user), user: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, user_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "email" => "some updated email",
        "first_name" => "some updated first_name",
        "last_name" => "some updated last_name",
        "linked_in_profile_id" => "some updated linked_in_profile_id",
        "oauth_linked_in_token" => "some updated oauth_linked_in_token",
        "password_hash" => "some updated password_hash",
        #"password_reset_at" => ~N[2011-05-18 15:01:01.000000],
        "password_reset_at" => "2011-05-18T15:01:01.000000",
        "password_reset_hash" => "some updated password_reset_hash",
        "system_role" => "some updated system_role"}
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete conn, user_path(conn, :delete, user)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, user_path(conn, :show, user)
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
