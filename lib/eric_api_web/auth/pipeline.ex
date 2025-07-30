defmodule EricApiWeb.Auth.Pipeline do
  @moduledoc """
  The Auth Pipeline.
  """

  use Guardian.Plug.Pipeline,
    otp_app: :eric_api,
    module: EricApi.Adapters.Guardian,
    error_handler: EricApiWeb.Auth.GuardianErrorHandler

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource, allow_blank: true
end
