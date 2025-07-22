defmodule EricApi.Services.Guardian do
  @moduledoc """
  The Guardian service.
  """

  alias EricApi.Adapters.Guardian
  @adapter Application.compile_env(:eric_api, :guardian_adapter, Guardian)

  @spec subject_for_token(map(), map()) :: {:ok, String.t()} | {:error, atom()}
  def subject_for_token(user, claims), do: @adapter.subject_for_token(user, claims)
  @spec resource_from_claims(map()) :: {:ok, String.t()} | {:error, atom()}
  def resource_from_claims(claims), do: @adapter.resource_from_claims(claims)
  @spec authenticate(String.t(), String.t()) :: {:ok, String.t()} | {:error, atom()}
  def authenticate(email, password), do: @adapter.login(email, password)
end
