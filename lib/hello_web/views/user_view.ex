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
      full_name: "#{user.first_name} #{user.last_name}",
      oauth_linked_in_token: user.oauth_linked_in_token,
      linked_in_profile_id: user.linked_in_profile_id,
      system_role: user.system_role,
      password_reset_hash: user.password_reset_hash,
      password_reset_at: user.password_reset_at,
      avatar_url: avatar_url(user.email),
      created_at: user.inserted_at,
      updated_at: user.updated_at
    }
  end

  def avatar_url(email) do
    user_email_hash = :crypto.hash(:md5, email |> String.downcase)
                      |> Base.encode16
                      |> String.downcase

    "https://www.gravatar.com/avatar/#{user_email_hash}?default=identicon"
  end
end
