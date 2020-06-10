defmodule ContentsWeb.FileController do
  use ContentsWeb, :controller

  alias Contents.Files
  alias Contents.Files.File
  alias Contents.Files_lib
  alias Contents.ContentStartup

  require Logger

  action_fallback ContentsWeb.FallbackController

  def index(conn, _params) do
    files = Files.list_root()
    render(conn, "index.json", files: files)
  end

  def upload(conn, file_params) do
    Logger.info("check path: #{inspect(file_params)}")
    %{"file" => file_param} = file_params
    %{"parent_id" => parent_id_param} = file_params
    %{"type" => type_param} = file_params
    %{"upload_by" => uploaded_by_param} = file_params

    case Files.check_files!(parent_id_param, file_param.filename) do 
      [_] ->
        Logger.info("#{inspect(file_param.filename)} exist at parent id #{inspect(parent_id_param)}")
        conn
          |> render("errorAddFile.json")
      [] ->
        Logger.info("#{inspect(file_param.filename)} not exist at parent id #{inspect(parent_id_param)}")

        case Files_lib.file_path(parent_id_param) do
          {:ok, filepath} ->
            Logger.info("file path #{inspect(filepath)}")
            to_path =  Enum.join([ContentStartup.static_path, filepath, file_param.filename], "/")
            Logger.info("to_path #{inspect(to_path)}")
            case Files_lib.copy_temp_static(file_param.path, to_path) do
              {:ok, size, format} ->

                save_this_file =  %{
                  "parent_id" => parent_id_param,
                  "filename" => file_param.filename,
                  "path" => filepath,
                  "type" => type_param,
                  "format" => format,
                  "size" => size,
                  "upload_by" => uploaded_by_param
                }

                Logger.info("save_this_file #{inspect(save_this_file)}")
                with {:ok, %File{} = file} <- Files.create_file(save_this_file) do
                  conn
                    |> put_status(:created)
                    |> render("show.json", file: file)
                end
              _ ->
                Logger.info("Error copy")
                conn
                  |> render("errorAddFile.json")
            end
          {:error, _error} ->
            conn
              |> render("errorAddFile.json")
        end
    end
  end

  def create(conn, %{"directory" => file_params}) do
    case Files.check_files!(file_params["parent_id"], file_params["filename"]) do 
      [_] ->
        conn
          |> render("errorAddDir.json")
      [] ->
        case Files_lib.file_path(file_params["parent_id"]) do
          {:ok, filepath} ->
            Logger.info("filepath #{inspect(filepath)}")
            target = Enum.join([ContentStartup.static_path, filepath, file_params["filename"]], "/")
            case Files_lib.create_dir(target) do
              :ok ->

                save_this_file =  %{
                  "parent_id" => file_params["parent_id"],
                  "filename" => file_params["filename"],
                  "path" => filepath,
                  "type" => "dir",
                  "format" => "folder",
                  "upload_by" => file_params["upload_by"]
                }

                with {:ok, %File{} = file} <- Files.create_file(save_this_file) do
                  conn
                  |> put_status(:created)
                  |> render("show.json", file: file)
                end
              _ ->
                conn
              |> render("errorAddDir.json")
            end
          {:error, _error} ->
            conn
              |> render("errorAddDir.json")
        end
      end
  end

  def show(conn, %{"id" => id}) do
    file = Files.get_file!(id)
    render(conn, "show.json", file: file)
  end

  def show_files(conn, %{"id" => id}) do
    files = Files.list_files!(id)
    render(conn, "index.json", files: files)
  end

  def update(conn, %{"id" => id, "file" => file_params}) do
    file = Files.get_file!(id)

    with {:ok, %File{} = file} <- Files.update_file(file, file_params) do
      render(conn, "show.json", file: file)
    end
  end

  def delete(conn, %{"id" => id}) do
    file = Files.get_file!(id)

    with {:ok, %File{}} <- Files.delete_file(file) do
      send_resp(conn, :no_content, "")
    end
  end
end
