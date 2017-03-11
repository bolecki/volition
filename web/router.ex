defmodule Volition.Router do
  use Volition.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Volition do
    pipe_through :browser # Use the default browser stack

    get "/", GameController, :index

    resources "/players", PlayerController
    resources "/areas", AreaController
    resources "/nearbys", NearbyController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Volition do
  #   pipe_through :api
  # end
end
