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

  defmodule Cache do
    @name :redirect

    def start_link, do: Agent.start_link(&load/0, name: @name)
    def update, do: Agent.update(@name, &load(&1))
    # This exists just until I can figure out the test issues with redirect#match
    def update(overides), do: Agent.update(@name, &all(&1, overides))

    def get, do: Agent.get(@name, &all(&1))
    def get(domain, path), do: Agent.get(@name, &find(&1, domain, path))

    defp all(redirects), do: redirects
    defp all(redirects, overides), do: overides
    defp load(_ \\ nil), do: Extemporize.Repo.all(Extemporize.Redirect)
    defp find(redirects, domain, path), do: Enum.find(redirects, &match(&1, domain, path))
    defp match(redirect, domain, path), do: Map.get(redirect, :domain) == domain && Map.get(redirect, :path) == path
  end
end
