defmodule EricApi.Adapters.Guardian do
  @moduledoc """
  The Guardian adapter.
  """

  use Guardian, otp_app: :eric_api
  alias EricApi.Services.Accounts

  @spec subject_for_token(map(), map()) :: {:ok, String.t()} | {:error, atom()}
  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  def subject_for_token(_user, _claims), do: {:error, :no_id_provided}

  @spec resource_from_claims(map()) :: {:ok, String.t()} | {:error, atom()}
  def resource_from_claims(%{"sub" => id}) do
    case Accounts.get_user!(id) do
      %{} = user -> create_token(user)
      _err -> {:error, :no_user_found}
    end
  end

  def resource_from_claims(_claims), do: {:error, :no_id_provided}

  @spec login(String.t(), String.t()) :: {:ok, String.t()} | {:error, :invalid_credentials}
  def login(email, password) do
    with %{password: hash} = user <- Accounts.get_by(email: email),
         true <- Bcrypt.verify_pass(password, hash) do
      create_token(user)
    else
      _errors -> {:error, :invalid_credentials}
    end
  end

  defp create_token(%{id: id}) do
    {:ok, token, _claims} = encode_and_sign(%{id: id})
    {:ok, token}
  end
end
