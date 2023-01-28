defmodule RumblWeb.Plugs.AuthTest do
  use RumblWeb.ConnCase, async: true

  @subject RumblWeb.Plugs.Auth
  alias Rumbl.Accounts.User

  setup %{conn: conn} do
    conn =
      conn
      |> bypass_through(RumblWeb.Router, :browser)
      |> get("/")

    {:ok, %{conn: conn}}
  end

  describe "authenticate_user/2" do
    test "halts when no current_user exists", %{conn: conn} do
      conn = @subject.authenticate_user(conn, [])
      assert conn.halted
    end

    test "for existing current_user", %{conn: conn} do
      conn =
        conn
        |> assign(:current_user, %Rumbl.Accounts.User{})
        |> @subject.authenticate_user([])

      refute conn.halted
    end
  end

  describe "login/1" do
    test "login puts the user in the session", %{conn: conn} do
      login_conn =
        conn
        |> @subject.login(%User{id: 123})
        |> send_resp(:ok, "")

      next_conn = get(login_conn, "/")
      assert get_session(next_conn, :user_id) == 123
    end
  end

  describe "logout/1" do
    test "logout drops the session", %{conn: conn} do
      logout_conn =
        conn
        |> put_session(:user_id, 123)
        |> @subject.logout()
        |> send_resp(:ok, "")

      next_conn = get(logout_conn, "/")
      refute get_session(next_conn, :user_id)
    end
  end

  describe "call/2" do
    test "call places user from session into assigns", %{conn: conn} do
      user = user_fixture()

      conn =
        conn
        |> put_session(:user_id, user.id)
        |> @subject.call(@subject.init([]))

      assert conn.assigns.current_user.id == user.id
    end

    test "call with no session sets current_user assign to nil", %{conn: conn} do
      conn = @subject.call(conn, @subject.init([]))
      assert conn.assigns.current_user == nil
    end
  end
end
