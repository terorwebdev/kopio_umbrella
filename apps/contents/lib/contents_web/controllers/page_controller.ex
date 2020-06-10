defmodule ContentsWeb.PageController do
  use ContentsWeb, :controller

  def index(conn, _params) do
    conn
      |> delete_resp_header("x-frame-options")
      |> render("index.html")
  end
end
