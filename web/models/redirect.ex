defmodule Extemporize.Redirect do
  use Extemporize.Web, :model

  schema "redirects" do
    field :domain, :string
    field :path, :string
    field :destination, :string

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:domain, :path, :destination])
    |> strip_whitespace([:domain, :path, :destination])
    |> validate_required([:domain, :path, :destination])
    |> unique_constraint(:domain, name: :redirects_domain_path_index)
  end

  def match(domain, path) do
    from r in __MODULE__,
    select: [:destination],
    where: r.domain == ^domain,
    where: r.path == ^path
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
