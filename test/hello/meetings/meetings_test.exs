defmodule Hello.MeetingsTest do
  use Hello.DataCase

  alias Hello.Meetings

  describe "meetings" do
    alias Hello.Meetings.Meeting

    @valid_attrs %{description: "some description", name: "some name", shortcode: "some shortcode", status: "some status"}
    @update_attrs %{description: "some updated description", name: "some updated name", shortcode: "some updated shortcode", status: "some status"}
    @invalid_attrs %{description: nil, name: nil, shortcode: nil, status: nil}

    def meeting_fixture(attrs \\ %{}) do
      {:ok, meeting} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Meetings.create_meeting()

      meeting
    end

    test "list_meetings/0 returns all meetings" do
      meeting = meeting_fixture()
      assert Meetings.list_meetings() == [meeting]
    end

    test "get_meeting!/1 returns the meeting with given id" do
      meeting = meeting_fixture()
      assert Meetings.get_meeting!(meeting.id) == meeting
    end

    test "create_meeting/1 with valid data creates a meeting" do
      assert {:ok, %Meeting{} = meeting} = Meetings.create_meeting(@valid_attrs)
      assert meeting.description == "some description"
      assert meeting.name == "some name"
      assert meeting.shortcode == "some shortcode"
      assert meeting.status == "some status"
    end

    test "create_meeting/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Meetings.create_meeting(@invalid_attrs)
    end

    test "update_meeting/2 with valid data updates the meeting" do
      meeting = meeting_fixture()
      assert {:ok, meeting} = Meetings.update_meeting(meeting, @update_attrs)
      assert %Meeting{} = meeting
      assert meeting.description == "some updated description"
      assert meeting.name == "some updated name"
      assert meeting.shortcode == "some updated shortcode"
      assert meeting.status == "some status"
    end

    test "update_meeting/2 with invalid data returns error changeset" do
      meeting = meeting_fixture()
      assert {:error, %Ecto.Changeset{}} = Meetings.update_meeting(meeting, @invalid_attrs)
      assert meeting == Meetings.get_meeting!(meeting.id)
    end

    test "delete_meeting/1 deletes the meeting" do
      meeting = meeting_fixture()
      assert {:ok, %Meeting{}} = Meetings.delete_meeting(meeting)
      assert_raise Ecto.NoResultsError, fn -> Meetings.get_meeting!(meeting.id) end
    end

    test "change_meeting/1 returns a meeting changeset" do
      meeting = meeting_fixture()
      assert %Ecto.Changeset{} = Meetings.change_meeting(meeting)
    end
  end
end
