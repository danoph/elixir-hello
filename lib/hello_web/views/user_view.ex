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
      system_role: user.system_role,
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
