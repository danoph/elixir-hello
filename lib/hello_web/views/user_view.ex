defmodule HelloWeb.UserView do
  use HelloWeb, :view
  alias HelloWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      password_hash: user.password_hash,
      oauth_linked_in_token: user.oauth_linked_in_token,
      linked_in_profile_id: user.linked_in_profile_id,
      system_role: user.system_role,
      password_reset_hash: user.password_reset_hash,
      password_reset_at: user.password_reset_at}
  end
end
