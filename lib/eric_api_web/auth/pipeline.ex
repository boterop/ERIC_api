defmodule EricApiWeb.Auth.Pipeline do
  @moduledoc """
  The Auth Pipeline.
  """

  use Guardian.Plug.Pipeline,
    otp_app: :eric_api,
    module: EricApi.Adapters.Guardian,
    error_handler: EricApiWeb.Auth.GuardianErrorHandler

  plug Guardian.Plug.VerifyHeader, header_name: "authentication"
  plug Guardian.Plug.EnsureAuthenticated, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, allow_blank: true
end
