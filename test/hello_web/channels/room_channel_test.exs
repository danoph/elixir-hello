defmodule HelloWeb.RoomChannelTest do
  use HelloWeb.ChannelCase

  alias HelloWeb.RoomChannel

  alias Hello.Meetings
  alias Hello.Meetings.Meeting
  alias Hello.Users

  @create_attrs %{description: "some description", name: "some name", shortcode: "some shortcode", status: "some status"}

  def fixture(:meeting) do
    {:ok, meeting} = Meetings.create_meeting(@create_attrs)
    meeting
  end

  @user_create_attrs %{email: "some email", first_name: "some first_name", last_name: "some last_name", linked_in_profile_id: "some linked_in_profile_id", oauth_linked_in_token: "some oauth_linked_in_token", password_hash: "some password_hash", password_reset_at: ~N[2010-04-17 14:00:00.000000], password_reset_hash: "some password_reset_hash", system_role: "some system_role"}

  def fixture(:user) do
    {:ok, user} = Users.create_user(@user_create_attrs)
    user
  end

  setup do
    {:ok, _, socket} =
      socket("user_id", %{user_id: :assign})
      |> subscribe_and_join(RoomChannel, "room:lobby")

    {:ok, socket: socket}
  end

  test "ping replies with status ok", %{socket: socket} do
    ref = push socket, "ping", %{"hello" => "there"}
    assert_reply ref, :ok, %{"hello" => "there"}
  end

  describe "authenticate" do
    setup [:create_user]

    test "api.authenticate", %{socket: socket} do
      ref = push socket, "api.authenticate", %{"hello" => "there"}
      assert_reply ref, :ok, %{"hello" => "there"}
    end

    defp create_user(_) do
      user = fixture(:user)
      {:ok, user: user}
    end
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

  describe "getting meetings from database" do
    setup [:create_meeting]

    #test "gets meetings", %{socket: socket, meeting: meeting} do
    #ref = push socket, "api.meetings.get"

    #expected_meetings = [
    #%{
    #"id" => meeting.id,
    #"name" => meeting.name,
    #"description" => meeting.description,
    #"status" => meeting.status,
    #"shortcode": meeting.shortcode,
    #}
    #]

    #assert_reply ref, :ok, %{ "data": [] }
    #end

    #test "gets meetings", %{socket: socket, meeting: meeting} do
    test "gets meetings", %{socket: socket, meeting: %Meeting{id: id, name: name, description: description, status: status, shortcode: shortcode } = meeting} do
      #test "gets meetings", %{socket: socket, meeting: %Meeting{id: id } = meeting} do
      ref = push socket, "api.meetings.get"

      #assert Meetings.get_meeting!(meeting.id) == meeting

      #expected_reply = %{
      #data: [
      #%{
      ##"description" => meeting.description,
      #"id" => id,
      ##"name" => meeting.name,
      ##"status" => meeting.status,
      ##"shortcode": meeting.shortcode,
      #}
      #]
      #}

      #assert_reply ref, :ok, ^expected_reply

      assert_reply ref, :ok, %{ data: [ %{ "id": ^id, name: ^name, description: ^description, status: ^status, shortcode: ^shortcode } ] }
    end

    defp create_meeting(_) do
      meeting = fixture(:meeting)
      {:ok, meeting: meeting}
    end
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from! socket, "broadcast", %{"some" => "data"}
    assert_push "broadcast", %{"some" => "data"}
  end
end
