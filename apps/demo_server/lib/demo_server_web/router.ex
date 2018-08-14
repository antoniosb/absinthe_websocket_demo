defmodule DemoServerWeb.Router do
  use DemoServerWeb, :router

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

  scope "/", DemoServerWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/employees", EmployeeController
  end


  # Other scopes may use custom stacks.
  # scope "/api", DemoServerWeb do
  #   pipe_through :api
  # end
end
