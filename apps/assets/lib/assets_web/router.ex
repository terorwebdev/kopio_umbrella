defmodule AssetsWeb.Router do
  use AssetsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Plug.Static
  end

  pipeline :static do
    plug Plug.Static,
      at: "asset/static",
      from: {:assets, "priv/static"}
  end

  scope "/", AssetsWeb do
    scope "asset/static" do
      pipe_through :static
      get "/*path", ErrorController, :notfound
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", AssetsWeb do
  #   pipe_through :api
  # end
end
