defmodule CosculWeb.Router do
  use CosculWeb, :router

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

  scope "/", CosculWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/items", ItemController
    resources "/recipes", RecipeController
  end

  scope "/api", CosculWeb.Api, as: :api do
    pipe_through :api

    resources "/recipes", RecipeController
  end
end
