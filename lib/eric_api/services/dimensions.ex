defmodule EricApi.Services.Dimensions do
  @moduledoc """
  dimensions use case.
  """
  @behaviour EricApi.Ports.AnswerRepo

  alias EricApi.Adapters.Dimensions
  @adapter Application.compile_env(:eric_api, :dimension_adapter, Dimensions)

  @impl true
  def list_answers, do: @adapter.list_answers()
  @impl true
  def get_answer!(id), do: @adapter.get_answer!(id)
  @impl true
  def get_by(attrs), do: @adapter.get_by(attrs)
  @impl true
  def get_all_by(attrs), do: @adapter.get_all_by(attrs)
  @impl true
  def create_answer(attrs \\ %{}), do: @adapter.create_answer(attrs)
  @impl true
  def update_answer(answer, attrs), do: @adapter.update_answer(answer, attrs)
  @impl true
  def delete_answer(answer), do: @adapter.delete_answer(answer)
  @impl true
  def change_answer(answer, attrs \\ %{}), do: @adapter.change_answer(answer, attrs)
end
