defmodule RumblWeb.VideoControllerTest do
  use RumblWeb.ConnCase, async: true

  setup %{conn: conn} = config do
    if username = config[:login_as] do
      user = user_fixture(username: username)
      conn = assign(conn, :current_user, user)
      {:ok, conn: conn, user: user}
    else
      :ok
    end
  end

  test "requires use authentication on all actions", %{conn: conn} do
    Enum.each([
      get(conn, Routes.video_path(conn, :new)),
      get(conn, Routes.video_path(conn, :index)),
      get(conn, Routes.video_path(conn, :show, "123")),
      get(conn, Routes.video_path(conn, :edit, "123")),
      get(conn, Routes.video_path(conn, :update, "123", %{})),
      get(conn, Routes.video_path(conn, :create, %{})),
      get(conn, Routes.video_path(conn, :delete, "123")),
    ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end

  @tag login_as: "user1"
  test "list all user's videos on index", %{conn: conn, user: user} do
    user_video = video_fixture(user, title: "funny cats")
    other_video = video_fixture(user_fixture(username: "other"), title: "another video")

    conn = get conn, Routes.video_path(conn, :index)
    assert html_response(conn, 200) =~ ~r/Listing Videos/
    assert String.contains?(conn.resp_body, user_video.title)
    refute String.contains?(conn.resp_body, other_video.title)
  end
end
