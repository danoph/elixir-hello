defmodule HelloWeb.RoomChannel do
  use HelloWeb, :channel
  alias HelloWeb.Presence

  alias Hello.Meetings
  alias HelloWeb.MeetingView
  #alias Hello.Meetings.Meeting

  alias Hello.Users

  alias Hello.Tokens
  alias Hello.Tokens.Token
  alias HelloWeb.TokenView

  def join("room:lobby", _params, socket) do
    send(self(), :after_join)
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    #IO.puts "socket: #{socket}"
    push socket, "presence_state", Presence.list(socket)
    {:ok, _} = Presence.track(socket, socket.assigns.user_id, %{
      online_at: inspect(System.system_time(:seconds))
    })
    {:noreply, socket}
  end

  #def join("room:lobby", payload, socket) do
    #if authorized?(payload) do
      #{:ok, socket}
    #else
      #{:error, %{reason: "unauthorized"}}
    #end
  #end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  def handle_in("api.meetings.get", _, socket) do
    meetings = Meetings.list_meetings()
    #{:reply, {:ok, %{data: [ %{ name: 'somasdasdf' } ] } }, socket}
    {:reply, {:ok, MeetingView.render("index.json", %{meetings: meetings}) }, socket}
  end

  def handle_in("api.authenticate", %{ "email" => email, "password" => password }, socket) do
    user = Users.get_by(%{ email: email, password: password })
    token_string = Phoenix.Token.sign(socket, "user salt", user.id)

    #{:ok, user_id} = Phoenix.Token.verify(socket, "user salt", token, max_age: 86400)
    #{:error, :invalid} = Phoenix.Token.verify(socket, "user salt", token, max_age: 86400)
    #{:error, :invalid} = Phoenix.Token.verify(socket, "user salt2", token, max_age: 86400)


    with {:ok, %Token{} = token} <- Tokens.create_token(%{ token: token_string, user_id: user.id }) do
      {:reply, {:ok, TokenView.render("show.json", %{token: token_string}) }, socket}
      #conn
      #|> put_status(:created)
      #|> put_resp_header("location", token_path(conn, :show, token))
      #|> render("show.json", token: token)
    end

    #token_obj = %{ token: token, user: user }
    #{:reply, {:ok, TokenView.render("show.json", %{token: token_obj}) }, socket}
    #{:reply, {:ok, TokenView.render("show.json", %{token: token_string}) }, socket}
  end

  def handle_in("api.status", _, socket) do
    datetime = Ecto.DateTime.utc(:usec)
    server_ts = datetime
               |> Ecto.DateTime.to_erl
               |> :calendar.datetime_to_gregorian_seconds
               |> Kernel.-(62167219200)
               |> Kernel.*(1000000)
               |> Kernel.+(datetime.usec)
               |> div(1000)

    {:reply, {:ok, %{ status: "up", server_ts: server_ts } }, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    broadcast! socket, "new_msg", %{body: body}
    {:noreply, socket}
  end

  intercept ["user_joined"]

  def handle_out("user_joined", msg, socket) do
    #if Accounts.ignoring_user?(socket.assigns[:user], msg.user_id) do
      #{:noreply, socket}
    #else
      push socket, "user_joined", msg
      {:noreply, socket}
    #end
  end

  # Add authorization logic here as required.
  #defp authorized?(_payload) do
    #true
  #end
end
