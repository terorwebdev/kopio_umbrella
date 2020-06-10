defmodule ContentsWeb.Router do
  use ContentsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug CORSPlug, origin: "*"
    #plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ContentsWeb do
    pipe_through :browser

    get "/", PageController, :index

    get "/content", FileController, :index
    get "/content/parent_id/:id", FileController, :show_files
    post "/content/dir/add", FileController, :create
    post "/content/file/upload", FileController, :upload
    post "/content/rename/parent_id/:id", FileController, :index
    post "/content/move/parent_id/:id", FileController, :index
    post "/content/copy/parent_id/:id", FileController, :index
    post "/content/delete/parent_id/:id", FileController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", ContentsWeb do
  #   pipe_through :api
  # end
end
