defmodule Rumbl.Fixtures do
  @moduledoc """
    This module defines test fixtures
  """

  alias Rumbl.{Accounts, Multimedia}

  @doc """
    Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        name: "Guilherme",
        username: "guisfits#{System.unique_integer([:positive])}",
        password: attrs[:password] || "1234abc"
      })
      |> Accounts.register_user()

    user
  end

  @doc """
    Generate a video.
  """
  def video_fixture(%Accounts.User{} = user, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        title: "some title",
        url: "https://youtube.com",
        description: "some description"
      })

    {:ok, video} = Multimedia.create_video(user, attrs)

    video
  end
end
