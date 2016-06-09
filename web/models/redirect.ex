defmodule Extemporize.Redirect do
  use Extemporize.Web, :model

  schema "redirects" do
    field :pattern, :string
    field :destination, :string

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:pattern, :destination])
    |> strip_whitespace([:pattern, :destination])
    |> validate_required([:pattern, :destination])
    |> unique_constraint(:pattern)
  end

  def match(query \\ __MODULE__, pattern) do
    from r in query, select: [:destination], where: r.pattern == ^pattern
  end

  defp strip_whitespace(changeset, fields) when is_list(fields) do
    Enum.reduce(fields, changeset, &strip_whitespace(&2, &1))
  end

  defp strip_whitespace(changeset, field) do
    if Map.has_key?(changeset.changes, field) do
      value = get_change(changeset, field) |> String.strip
      put_change(changeset, field, value)
    else
      changeset
    end
  end
end
