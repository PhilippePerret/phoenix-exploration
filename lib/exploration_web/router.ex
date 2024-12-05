defmodule ExplorationWeb.Router do
  use ExplorationWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ExplorationWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/explorer", ExplorationWeb do
    pipe_through :browser

    get "/tasker", ExplorerTaskerController, :explorer
    get "/tasker/:page", ExplorerTaskerController, :explorer
    get "/ldq", ExplorerLdQController, :explorer
    get "/ldq/:page", ExplorerLdQController, :explorer
    get "/markdown/:page", ExplorerMarkdownController, :explorer
  end

  scope "/", ExplorationWeb do
    pipe_through :browser

    get "/:page", PageController, :show
    get "/", PageController, :accueil

  end

  # Other scopes may use custom stacks.
  # scope "/api", ExplorationWeb do
  #   pipe_through :api
  # end

  # Enable Swoosh mailbox preview in development
  if Application.compile_env(:exploration, :dev_routes) do

    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
