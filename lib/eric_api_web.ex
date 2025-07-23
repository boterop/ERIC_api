defmodule EricApiWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, components, channels, and so on.

  This can be used in your application as:

      use EricApiWeb, :controller
      use EricApiWeb, :html

  The definitions below will be executed for every controller,
  component, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define additional modules and import
  those modules here.
  """

  @spec static_paths :: list(binary())
  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt)

  @spec router :: any()
  def router do
    quote do
      use Phoenix.Router, helpers: false

      # Import common connection and controller functions to use in pipelines
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  @spec channel :: any()
  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  @spec controller :: any()
  def controller do
    quote do
      use Phoenix.Controller,
        formats: [:html, :json],
        layouts: [html: EricApiWeb.Layouts]

      use Gettext, backend: EricApiWeb.Gettext

      import Plug.Conn

      unquote(verified_routes())
    end
  end

  @spec verified_routes :: any()
  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: EricApiWeb.Endpoint,
        router: EricApiWeb.Router,
        statics: EricApiWeb.static_paths()
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/live_view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
