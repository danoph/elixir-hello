defmodule HelloWeb.TokenView do
  use HelloWeb, :view
  alias HelloWeb.TokenView
  alias HelloWeb.UserView

  def render("index.json", %{tokens: tokens}) do
    %{data: render_many(tokens, TokenView, "token.json")}
  end

  def render("show.json", %{token: token}) do
    %{data: render_one(token, TokenView, "token.json")}
  end

  def render("token.json", %{token: token}) do
    %{ token: "hello" }
    #%{ token: token }
  end

  #def render("token.json", %{token: token}) do
    #%{ token: token.token, user: UserView.render("user.json", %{ user: token.user }) }
  #end
end
