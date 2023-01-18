defmodule Rumbl.MultimediaFixtures do
  @moduledoc """
    This module defines test helpers for creating
    entities via the `Rumbl.Multimedia` context.
  """

  @doc """
    Generate a video.
  """
  def video_fixture(attrs \\ %{}) do
    {:ok, video} =
      attrs
      |> Enum.into(%{
        description: "some description",
        title: "some title",
        url: "https://youtube.com"
      })
      |> Rumbl.Multimedia.create_video()

    video
  end

  @doc """
    Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        name: "Guilherme",
        username: "guisfits#{System.unique_integer([:positive])}",
        password: "1234abc",
      })
      |> Rumbl.Accounts.create_user()

    user
  end
end
