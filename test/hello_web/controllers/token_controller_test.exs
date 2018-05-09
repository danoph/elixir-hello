defmodule HelloWeb.TokenControllerTest do
  use HelloWeb.ConnCase

  alias Hello.Tokens
  alias Hello.Tokens.Token
  alias Hello.Users
  alias Hello.Users.User

  @create_attrs %{token: "some token"}
  @update_attrs %{token: "some updated token"}
  @invalid_attrs %{token: nil}

  def fixture(:token) do
    {:ok, token} = Tokens.create_token(@create_attrs)
    token
  end

  @user_create_attrs %{email: "some email", first_name: "some first_name", last_name: "some last_name", linked_in_profile_id: "some linked_in_profile_id", oauth_linked_in_token: "some oauth_linked_in_token", password_hash: "some password_hash", password_reset_at: ~N[2010-04-17 14:00:00.000000], password_reset_hash: "some password_reset_hash", system_role: "some system_role"}

  def fixture(:user) do
    {:ok, user} = Users.create_user(@user_create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all tokens", %{conn: conn} do
      conn = get conn, token_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create token" do
    setup [:create_user]

    test "renders token when data is valid", %{conn: conn} do
      conn = post conn, token_path(conn, :create), email: @user_create_attrs.email, password: "password"
      assert %{"id" => id} = json_response(conn, 201)["data"]

      #conn = get conn, token_path(conn, :show, id)
      #assert json_response(conn, 200)["data"] == %{
        #"token": %{
          #"id" => id,
          #"token" => "some token"
        #}
      #}
    end

    #test "renders token when data is valid", %{conn: conn} do
      #conn = post conn, token_path(conn, :create), token: @create_attrs
      #assert %{"id" => id} = json_response(conn, 201)["data"]

      #conn = get conn, token_path(conn, :show, id)
      #assert json_response(conn, 200)["data"] == %{
        #"id" => id,
        #"token" => "some token"}
    #end

    #test "renders errors when data is invalid", %{conn: conn} do
      #conn = post conn, token_path(conn, :create), token: @invalid_attrs
      #assert json_response(conn, 422)["errors"] != %{}
    #end
  end

  #describe "update token" do
    #setup [:create_token]

    #test "renders token when data is valid", %{conn: conn, token: %Token{id: id} = token} do
      #conn = put conn, token_path(conn, :update, token), token: @update_attrs
      #assert %{"id" => ^id} = json_response(conn, 200)["data"]

      #conn = get conn, token_path(conn, :show, id)
      #assert json_response(conn, 200)["data"] == %{
        #"id" => id,
        #"token" => "some updated token"}
    #end

    #test "renders errors when data is invalid", %{conn: conn, token: token} do
      #conn = put conn, token_path(conn, :update, token), token: @invalid_attrs
      #assert json_response(conn, 422)["errors"] != %{}
    #end
  #end

  #describe "delete token" do
    #setup [:create_token]

    #test "deletes chosen token", %{conn: conn, token: token} do
      #conn = delete conn, token_path(conn, :delete, token)
      #assert response(conn, 204)
      #assert_error_sent 404, fn ->
        #get conn, token_path(conn, :show, token)
      #end
    #end
  #end

  defp create_token(_) do
    token = fixture(:token)
    {:ok, token: token}
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
