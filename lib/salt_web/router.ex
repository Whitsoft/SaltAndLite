defmodule SaltWeb.Router do
  use SaltWeb, :router
  # use Phoenix.Router
  # alias Salt.Plug.AuthenticateUserSession

  ############################################################################
  # See https://www.youtube.com/watch?v=DHwUmDrWNys&ab_channel=AlchemistCamp #
  # (1) Find the matching route                                              #
  # (2) Dispatch the matching function                                       #
  # NOTE: The router pipelines the conn structure in to the controller       #
  ############################################################################

  @options [:show, :new, :create, :edit, :update, :delete, :index]
  @ioptions [:edit, :update, :new, :show, :create, :delete]
  @roptions [:show, :new, :create, :index, :delete]
  @soptions [:show, :index, :create]

  pipeline :browser do
    plug(:accepts, ["html, json"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {SaltWeb.LayoutView, :root})
    # plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    # plug(AuthenticateUserSession)
    plug(SaltWeb.Authenticator)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", SaltWeb do
    pipe_through(:browser)
    #########################################
    # pass conn thru the :browser pipeline  #
    # Stored dispatch function for "/" is   #
    #  fn conn ->                           #
    #    plug = SaltWeb.PageController   #
    #    opts = plug.init(:index)           #
    #    plug.call(conn, opts) _ init META  #
    #########################################

    get("/", PageController, :index)
    resources "/class", ShowclassController, only: [:show, :edit, :update]
    resources("/selectclasses", SelectclassController, only: @soptions)
    resources("/users", UserController)
    # look into this singleton: true)
    resources("/profiles", ProfileController, only: @ioptions, singleton: true)
    resources("/classtitles", ClasstitleController, only: @options)
    resources("/classes", ClassController, only: @options)
    ######################################################################
    #  student_class_path and student_registration_path nested resources #
    ######################################################################
    resources "/students", StudentController, only: @options do
      resources("/registrations", RegistrationController, only: @roptions)
    end

    delete("/logout", SessionController, :delete)
    get("/login", SessionController, :new)
    post("/login", SessionController, :create)
  end

  scope "/api", SaltWeb do
    # pipe_through(:json_api)

    resources "/students", StudentController, only: [:new] do
      #  resources("/registrations", RegistrationController, only: [:delete])
    end
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    # import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through(:browser)

      # live_dashboard("/dashboard", metrics: SaltWeb.Telemetry)
    end
  end

  defp put_csrf_token_in_session(conn, _) do
    Plug.CSRFProtection.get_csrf_token()
    conn |> put_session("_csrf_token", Process.get(:plug_unmasked_csrf_token))
  end

  IO.inspect(:application.get_key(:my_app, :modules))
end
