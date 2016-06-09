defmodule Extemporize.Router do
  use Extemporize.Web, :router

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

  scope "/", Extemporize do
    pipe_through :browser # Use the default browser stack

    get "/", RedirectController, :index
    resources "/redirects", RedirectController
  end

  scope "/api", Extemporize do
    pipe_through :api

    get "/match", RedirectController, :match
  end
end
