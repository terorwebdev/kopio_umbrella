defmodule ContentsWeb.FileControllerTest do
  use ContentsWeb.ConnCase

  alias Contents.Files
  alias Contents.Files.File

  @create_attrs %{
    filename: "some filename",
    format: "some format",
    parent_id: "some parent_id",
    path: "some path",
    size: 42,
    type: "some type",
    upload_by: "some upload_by"
  }
  @update_attrs %{
    filename: "some updated filename",
    format: "some updated format",
    parent_id: "some updated parent_id",
    path: "some updated path",
    size: 43,
    type: "some updated type",
    upload_by: "some updated upload_by"
  }
  @invalid_attrs %{filename: nil, format: nil, parent_id: nil, path: nil, size: nil, type: nil, upload_by: nil}

  def fixture(:file) do
    {:ok, file} = Files.create_file(@create_attrs)
    file
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all files", %{conn: conn} do
      conn = get(conn, Routes.file_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create file" do
    test "renders file when data is valid", %{conn: conn} do
      conn = post(conn, Routes.file_path(conn, :create), file: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.file_path(conn, :show, id))

      assert %{
               "id" => id,
               "filename" => "some filename",
               "format" => "some format",
               "parent_id" => "some parent_id",
               "path" => "some path",
               "size" => 42,
               "type" => "some type",
               "upload_by" => "some upload_by"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.file_path(conn, :create), file: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update file" do
    setup [:create_file]

    test "renders file when data is valid", %{conn: conn, file: %File{id: id} = file} do
      conn = put(conn, Routes.file_path(conn, :update, file), file: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.file_path(conn, :show, id))

      assert %{
               "id" => id,
               "filename" => "some updated filename",
               "format" => "some updated format",
               "parent_id" => "some updated parent_id",
               "path" => "some updated path",
               "size" => 43,
               "type" => "some updated type",
               "upload_by" => "some updated upload_by"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, file: file} do
      conn = put(conn, Routes.file_path(conn, :update, file), file: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete file" do
    setup [:create_file]

    test "deletes chosen file", %{conn: conn, file: file} do
      conn = delete(conn, Routes.file_path(conn, :delete, file))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.file_path(conn, :show, file))
      end
    end
  end

  defp create_file(_) do
    file = fixture(:file)
    {:ok, file: file}
  end
end
