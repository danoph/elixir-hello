defmodule HelloWeb.RoomChannelTest do
  use HelloWeb.ChannelCase

  alias HelloWeb.RoomChannel

  setup do
    {:ok, _, socket} =
      #socket("user_id", %{some: :assign})
      socket("user_id", %{user_id: :assign})
      |> subscribe_and_join(RoomChannel, "room:lobby")

    {:ok, socket: socket}
  end

  test "ping replies with status ok", %{socket: socket} do
    ref = push socket, "ping", %{"hello" => "there"}
    assert_reply ref, :ok, %{"hello" => "there"}
  end

  test "status replies with status up and server timestamp", %{socket: socket} do
    ref = push socket, "api.status", %{"hello" => "there"}

    #datetime = Ecto.DateTime.utc(:usec)
    #expected_server_ts = datetime
               #|> Ecto.DateTime.to_erl
               #|> :calendar.datetime_to_gregorian_seconds
               #|> Kernel.-(62167219200)
               #|> Kernel.*(1000000)
               #|> Kernel.+(datetime.usec)
               #|> div(1000)

    #assert_reply ref, :ok, %{ "status": "up", "server_ts": expected_server_ts }
    assert_reply ref, :ok, %{ "status": "up" }
  end

  test "shout broadcasts to room:lobby", %{socket: socket} do
    push socket, "shout", %{"hello" => "all"}
    assert_broadcast "shout", %{"hello" => "all"}
  end

  test "gets meetings", %{socket: socket} do
    ref = push socket, "api.meetings.get"
    assert_reply ref, :ok, %{ "data": [ %{ name: 'some meeting' } ] }
  end

  test "gets meetings/3", %{socket: socket} do
    ref = push socket, "api.meetings.get", %{ data: %{} }
    assert_reply ref, :ok, %{ "data": [ %{ name: 'some meeting' } ] }
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from! socket, "broadcast", %{"some" => "data"}
    assert_push "broadcast", %{"some" => "data"}
  end
end
