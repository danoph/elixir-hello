defmodule HelloWeb.RoomChannel do
  use HelloWeb, :channel
  alias HelloWeb.Presence

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

    #create_table "meetings", force: :cascade do |t|
    #t.string   "name",               null: false
    #t.text     "description",        null: false
    #t.integer  "created_by_user_id", null: false
    #t.string   "status",             null: false
    #t.datetime "created_at",         null: false
    #t.datetime "updated_at",         null: false
    #t.integer  "current_topic_id"
    #t.citext   "shortcode",          null: false
    #t.index ["created_by_user_id"], name: "index_meetings_on_created_by_user_id", using: :btree
    #t.index ["current_topic_id"], name: "index_meetings_on_current_topic_id", using: :btree
  #end
  def handle_in("api.meetings.get", _, socket) do
    meeting1 = %{ name: "some meeting" }

    {:reply, {:ok, %{ data: [ meeting1 ] } }, socket}
  end

  def handle_in("api.status", _, socket) do
    #timestamp = DateTime.now.utc.to_datetime.strftime('%Q').to_i

    #timestamp = Ecto.Datetime.utc.to_datetime.strftime('%Q').to_i
    #datetime = Ecto.DateTime.utc(:usec)
               #|> Ecto.DateTime.to_erl

    #timestamp = datetime
    #|> Ecto.DateTime.to_erl
    #|> :calendar.datetime_to_gregorian_seconds
    #|> Kernel.-(62167219200)
    #|> Kernel.*(1000000)
    #|> Kernel.+(datetime.usec)
    #|> div(1000)
    #|> IO.inspect

    datetime = Ecto.DateTime.utc(:usec)
    server_ts = datetime
               |> Ecto.DateTime.to_erl
               |> :calendar.datetime_to_gregorian_seconds
               |> Kernel.-(62167219200)
               |> Kernel.*(1000000)
               |> Kernel.+(datetime.usec)
               |> div(1000)

    #{:reply, {:ok, { status: "up", server_ts: timestamp }, socket} }
    #{:reply, {:ok, { status: "up", server_ts: datetime }, socket} }
    #{:reply, {:ok, payload}, socket} # works
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
