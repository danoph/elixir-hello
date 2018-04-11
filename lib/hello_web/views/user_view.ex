defmodule HelloWeb.UserView do
  use HelloWeb, :view

  def render("index.json", %{users: users}) do
    %{
      data: Enum.map(users, &user_json/1)
    }
  end

  def user_json(user) do
    %{
      name: user.name,
      email: user.email,
      bio: user.bio,
      number_of_pets: user.number_of_pets
    }
  end
end
