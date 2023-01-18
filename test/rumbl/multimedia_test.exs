defmodule Rumbl.MultimediaTest do
  use Rumbl.DataCase

  alias Rumbl.Multimedia
  alias Rumbl.Multimedia.Video
  alias Rumbl.Accounts.User

  import Rumbl.MultimediaFixtures

  @invalid_attrs %{description: nil, title: nil, url: nil}

  describe "list_videos/0" do
    test "returns all videos" do
      video = video_fixture()
      assert Multimedia.list_videos() == [video]
    end
  end

  describe "get_video!/1" do
    test "returns the video with given id" do
      video = video_fixture()
      assert Multimedia.get_video!(video.id) == video
    end
  end

  describe "create_video/1" do
    test "with valid data creates a video" do
      user = user_fixture()
      valid_attrs = %{description: "some description", title: "some title", url: "some url"}

      assert {:ok, %Video{} = video} = Multimedia.create_video(user, valid_attrs)
      assert video.description == "some description"
      assert video.title == "some title"
      assert video.url == "some url"
    end

    test "with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Multimedia.create_video(user, @invalid_attrs)
    end
  end

  describe "update_video/2" do
    test "with valid data updates the video" do
      video = video_fixture()

      update_attrs = %{
        description: "some updated description",
        title: "some updated title",
        url: "some updated url"
      }

      assert {:ok, %Video{} = video} = Multimedia.update_video(video, update_attrs)
      assert video.description == "some updated description"
      assert video.title == "some updated title"
      assert video.url == "some updated url"
    end

    test "with invalid data returns error changeset" do
      video = video_fixture()
      assert {:error, %Ecto.Changeset{}} = Multimedia.update_video(video, @invalid_attrs)
      assert video == Multimedia.get_video!(video.id)
    end
  end

  describe "delete_video/1" do
    test " deletes the video" do
      video = video_fixture()
      assert {:ok, %Video{}} = Multimedia.delete_video(video)
      assert_raise Ecto.NoResultsError, fn -> Multimedia.get_video!(video.id) end
    end
  end

  describe "change_video/1" do
    test " returns a video changeset" do
      video = video_fixture()
      assert %Ecto.Changeset{} = Multimedia.change_video(video)
    end
  end

  describe "list_user_videos/1" do
    test "returns videos associated with the user" do
      user = user_fixture()
      video1 = video_fixture(user_id: user.id)
      video2 = video_fixture(user_id: user.id)
      video_fixture(user_id: user.id + 1)

      assert Multimedia.list_user_videos(user) == [video1, video2]
    end
  end
end
