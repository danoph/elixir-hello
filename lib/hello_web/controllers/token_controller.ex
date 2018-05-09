defmodule HelloWeb.TokenController do
  use HelloWeb, :controller

  alias Hello.Tokens
  alias Hello.Tokens.Token
  alias Hello.Users

  action_fallback HelloWeb.FallbackController

  def index(conn, _params) do
    tokens = Tokens.list_tokens()
    render(conn, "index.json", tokens: tokens)
  end

  #def create(conn, %{"token" => token_params}) do
    #with {:ok, %Token{} = token} <- Tokens.create_token(token_params) do
      #conn
      #|> put_status(:created)
      #|> put_resp_header("location", token_path(conn, :show, token))
      #|> render("show.json", token: token)
    #end
  #end

  #def create(conn, %{"email" => email, "password": password}) do
  def create(conn, _params) do
    user = List.last(Users.list_users)
    IO.puts "users: #{user.id}"
    #user = Users.get_user!(1)
    token = Phoenix.Token.sign(conn, "user salt", user.id)

    token_obj = %{ token: token, user: user }
    #IO.puts "token: #{token}"
    #{:ok, user_id} = Phoenix.Token.verify(conn, "user salt", token, max_age: 86400)
    #IO.puts "user_id: #{user_id}"
    #{:error, :invalid} = Phoenix.Token.verify(socket, "user salt", token, max_age: 86400)
    #{:error, :invalid} = Phoenix.Token.verify(socket, "user salt2", token, max_age: 86400)
    render(conn, "show.json", token: token_obj)
    #with {:ok, %Token{} = token} <- Tokens.create_token(token_params) do
      #conn
      #|> put_status(:created)
      #|> put_resp_header("location", token_path(conn, :show, token))
      #|> render("show.json", token: token)
    #end
  end

  def show(conn, %{"id" => id}) do
    token = Tokens.get_token!(id)
    render(conn, "show.json", token: token)
  end

  def update(conn, %{"id" => id, "token" => token_params}) do
    token = Tokens.get_token!(id)

    with {:ok, %Token{} = token} <- Tokens.update_token(token, token_params) do
      render(conn, "show.json", token: token)
    end
  end

  def delete(conn, %{"id" => id}) do
    token = Tokens.get_token!(id)
    with {:ok, %Token{}} <- Tokens.delete_token(token) do
      send_resp(conn, :no_content, "")
    end
  end
end
