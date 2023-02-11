defmodule RumblWeb.Fixtures do
  ##
  # %User{}

  @default_user %{
    name: "Some user",
    username: "user#{System.unique_integer([:positive])}",
    password: "supersecret"
  }

  def insert_user(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@default_user)
      |> Rumbl.Accounts.register_user()

    user
  end

  ##
  # %Video{}

  @default_video %{
    url: "https://youtube.com",
    description: "a youtube video",
    body: "body"
  }

  def insert_video(user, attrs \\ %{}) do
    video_attrs = Enum.into(attrs, @default_video)
    {:ok, video} = Rumbl.Multimedia.create_video(user, video_attrs)

    video
  end

  ##
  # Login

  def login(%{conn: conn, login_as: username}) do
    user = insert_user(username: username)
    {Plug.Conn.assign(conn, :current_user, user), user}
  end

  def login(%{conn: conn}) do
    {conn, :logged_out}
  end
end
