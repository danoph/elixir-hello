defmodule HelloWeb.MeetingView do
  use HelloWeb, :view
  alias HelloWeb.MeetingView

  def render("index.json", %{meetings: meetings}) do
    %{data: render_many(meetings, MeetingView, "meeting.json")}
  end

  def render("show.json", %{meeting: meeting}) do
    %{data: render_one(meeting, MeetingView, "meeting.json")}
  end

  def render("meeting.json", %{meeting: meeting}) do
    %{id: meeting.id,
      name: meeting.name,
      description: meeting.description,
      status: meeting.status,
      shortcode: meeting.shortcode,
      created_at: meeting.inserted_at,
      updated_at: meeting.updated_at,
    }
  end
end
