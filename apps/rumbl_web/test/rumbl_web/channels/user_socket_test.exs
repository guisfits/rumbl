defmodule RumblWeb.UserSocketTest do
  use RumblWeb.ConnCase, async: true

  @subject RumblWeb.UserSocket

  describe "authentication" do
    test "when the token is valid, should assign user_id" do
      token = Phoenix.Token.sign(@endpoint, "user socket", "1234")
      assert {:ok, socket} = connect(@subject, %{"token" => token})
      assert socket.assigns.user_id == "1234"
    end

    test "when the token is invalid, should return unauthorized" do
      assert connect(@subject, %{"token" => "invalid token"})
      assert connect(@subject, %{})
    end
  end
end
