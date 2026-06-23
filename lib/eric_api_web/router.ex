defmodule EricApiWeb.Router do
  use EricApiWeb, :router

  import Oban.Web.Router
  import Phoenix.LiveView.Router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug(EricApiWeb.Auth.Pipeline)
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {EricApiWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/api", EricApiWeb do
    pipe_through :api

    post "/login", UserController, :login
    post "/register", UserController, :create
    resources "/universities", UniversityController
    get "/countries", CountryController, :index

    scope "/gen-excel" do
      pipe_through :auth
      get "/", ScoreController, :gen_excel
    end

    scope "/answers" do
      pipe_through :auth
      resources "/", AnswerController
      get "/question/:question", AnswerController, :question
      get "/dimension/:dimension", AnswerController, :dimension
    end

    scope "/users" do
      pipe_through :auth
      get "/me", UserController, :me
      get "/students", UserController, :index_students
      resources "/", UserController, except: [:new, :edit]
    end
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:eric_api, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: EricApiWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end

    scope "/" do
      pipe_through :browser

      oban_dashboard("/oban")
    end
  end
end
