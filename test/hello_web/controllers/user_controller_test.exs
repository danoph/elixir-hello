defmodule HelloWeb.UserControllerTest do
  use HelloWeb.ConnCase

  alias Hello.Users

  @create_attrs %{bio: "some bio", email: "some email", name: "some name", number_of_pets: 42}
  @update_attrs %{bio: "some updated bio", email: "some updated email", name: "some updated name", number_of_pets: 43}
  @invalid_attrs %{bio: nil, email: nil, name: nil, number_of_pets: nil}

  def fixture(:user) do
    {:ok, user} = Users.create_user(@create_attrs)
    user
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get conn, user_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Users"
    end

    test "responds with json", %{conn: conn} do
      users = [%{name: "John", email: "john@example.com", bio: "john bio", number_of_pets: 123},
               %{name: "Jane", email: "jane@example.com", bio: "jane bio", number_of_pets: 541}]

      [{:ok, user1},{:ok, user2}] = Enum.map(users, &Users.create_user(&1))

      response =
        conn
        |> get("/api/users")
        |> json_response(200)

      expected = %{
        "data" => [
          %{ "name" => user1.name, "email" => user1.email, "bio" => user1.bio, "number_of_pets" => user1.number_of_pets },
          %{ "name" => user2.name, "email" => user2.email, "bio" => user2.bio, "number_of_pets" => user2.number_of_pets }
        ]
      }

      assert response == expected
    end
  end

  describe "new user" do
    test "renders form", %{conn: conn} do
      conn = get conn, user_path(conn, :new)
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "create user" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == user_path(conn, :show, id)

      conn = get conn, user_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show User"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @invalid_attrs
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "edit user" do
    setup [:create_user]

    test "renders form for editing chosen user", %{conn: conn, user: user} do
      conn = get conn, user_path(conn, :edit, user)
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "update user" do
    setup [:create_user]

    test "redirects when data is valid", %{conn: conn, user: user} do
      conn = put conn, user_path(conn, :update, user), user: @update_attrs
      assert redirected_to(conn) == user_path(conn, :show, user)

      conn = get conn, user_path(conn, :show, user)
      assert html_response(conn, 200) =~ "some updated bio"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete conn, user_path(conn, :delete, user)
      assert redirected_to(conn) == user_path(conn, :index)
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
