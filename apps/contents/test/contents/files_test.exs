defmodule Contents.FilesTest do
  use Contents.DataCase

  alias Contents.Files

  describe "files" do
    alias Contents.Files.File

    @valid_attrs %{filename: "some filename", format: "some format", parent_id: "some parent_id", path: "some path", size: 42, type: "some type", upload_by: "some upload_by"}
    @update_attrs %{filename: "some updated filename", format: "some updated format", parent_id: "some updated parent_id", path: "some updated path", size: 43, type: "some updated type", upload_by: "some updated upload_by"}
    @invalid_attrs %{filename: nil, format: nil, parent_id: nil, path: nil, size: nil, type: nil, upload_by: nil}

    def file_fixture(attrs \\ %{}) do
      {:ok, file} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Files.create_file()

      file
    end

    test "list_files/0 returns all files" do
      file = file_fixture()
      assert Files.list_files() == [file]
    end

    test "get_file!/1 returns the file with given id" do
      file = file_fixture()
      assert Files.get_file!(file.id) == file
    end

    test "create_file/1 with valid data creates a file" do
      assert {:ok, %File{} = file} = Files.create_file(@valid_attrs)
      assert file.filename == "some filename"
      assert file.format == "some format"
      assert file.parent_id == "some parent_id"
      assert file.path == "some path"
      assert file.size == 42
      assert file.type == "some type"
      assert file.upload_by == "some upload_by"
    end

    test "create_file/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Files.create_file(@invalid_attrs)
    end

    test "update_file/2 with valid data updates the file" do
      file = file_fixture()
      assert {:ok, %File{} = file} = Files.update_file(file, @update_attrs)
      assert file.filename == "some updated filename"
      assert file.format == "some updated format"
      assert file.parent_id == "some updated parent_id"
      assert file.path == "some updated path"
      assert file.size == 43
      assert file.type == "some updated type"
      assert file.upload_by == "some updated upload_by"
    end

    test "update_file/2 with invalid data returns error changeset" do
      file = file_fixture()
      assert {:error, %Ecto.Changeset{}} = Files.update_file(file, @invalid_attrs)
      assert file == Files.get_file!(file.id)
    end

    test "delete_file/1 deletes the file" do
      file = file_fixture()
      assert {:ok, %File{}} = Files.delete_file(file)
      assert_raise Ecto.NoResultsError, fn -> Files.get_file!(file.id) end
    end

    test "change_file/1 returns a file changeset" do
      file = file_fixture()
      assert %Ecto.Changeset{} = Files.change_file(file)
    end
  end
end
