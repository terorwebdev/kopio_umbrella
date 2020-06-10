defmodule ContentsWeb.FileView do
  use ContentsWeb, :view
  alias ContentsWeb.FileView

  def render("index.json", %{files: files}) do
    %{result: "success", data: render_many(files, FileView, "file.json")}
  end

  def render("show.json", %{file: file}) do
    %{result: "success", data: render_one(file, FileView, "file.json")}
  end

  def render("file.json", %{file: file}) do
    %{id: file.id,
      parent_id: file.parent_id,
      type: file.type,
      path: file.path,
      format: file.format,
      size: file.size,
      filename: file.filename,
      upload_by: file.upload_by}
  end

  def render("errorAddDir.json", _files) do
    %{result: "error", reason: "Folder exist in same folder"}
  end

  def render("errorAddFile.json", _files) do
    %{result: "error", reason: "Filename exist in same folder"}
  end

end
