defmodule KopioWeb.PageController do
  use KopioWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
