defmodule EricApiWeb.ChangesetJSON do
  @doc """
  Renders changeset errors.
  """
  @spec error(any()) :: map()
  def error(%{changeset: changeset}) do
    # When encoded, the changeset returns its errors
    # as a JSON object. So we just pass it forward.
    %{errors: Ecto.Changeset.traverse_errors(changeset, &translate_error/1)}
  end

  defp translate_error({msg, opts}) do
    # You can make use of gettext to translate error messages by
    # uncommenting and adjusting the following code:

    # if count = opts[:count] do
    #   Gettext.dngettext(EricApiWeb.Gettext, "errors", msg, msg, count, opts)
    # else
    #   Gettext.dgettext(EricApiWeb.Gettext, "errors", msg, opts)
    # end

    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", fn _error -> to_string(value) end)
    end)
  end
end
