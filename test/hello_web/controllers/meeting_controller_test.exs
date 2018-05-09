defmodule HelloWeb.MeetingControllerTest do
  use HelloWeb.ConnCase

  alias Hello.Meetings
  alias Hello.Meetings.Meeting

  @create_attrs %{description: "some description", name: "some name", shortcode: "some shortcode", status: "some status"}
  @update_attrs %{description: "some updated description", name: "some updated name", shortcode: "some updated shortcode", status: "some status"}
  @invalid_attrs %{description: nil, name: nil, shortcode: nil, status: nil}

  def fixture(:meeting) do
    {:ok, meeting} = Meetings.create_meeting(@create_attrs)
    meeting
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all meetings", %{conn: conn} do
      conn = get conn, meeting_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create meeting" do
    test "renders meeting when data is valid", %{conn: conn} do
      conn = post conn, meeting_path(conn, :create), meeting: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, meeting_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "description" => "some description",
        "name" => "some name",
        "shortcode" => "some shortcode",
        "status" => "some status",
        #"created_at": inserted_at,
        #"updated_at": updated_at
      }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, meeting_path(conn, :create), meeting: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update meeting" do
    setup [:create_meeting]

    test "renders meeting when data is valid", %{conn: conn, meeting: %Meeting{id: id, inserted_at: inserted_at, updated_at: updated_at } = meeting} do
      conn = put conn, meeting_path(conn, :update, meeting), meeting: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, meeting_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "description" => "some updated description",
        "name" => "some updated name",
        "shortcode" => "some updated shortcode",
        "status" => "some status",
        "created_at": inserted_at,
        "updated_at": updated_at
      }
    end

    test "renders errors when data is invalid", %{conn: conn, meeting: meeting} do
      conn = put conn, meeting_path(conn, :update, meeting), meeting: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete meeting" do
    setup [:create_meeting]

    test "deletes chosen meeting", %{conn: conn, meeting: meeting} do
      conn = delete conn, meeting_path(conn, :delete, meeting)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, meeting_path(conn, :show, meeting)
      end
    end
  end

  defp create_meeting(_) do
    meeting = fixture(:meeting)
    {:ok, meeting: meeting}
  end
end
