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
    |> validate_required([:pattern, :destination])
  end

  def match(query \\ __MODULE__, pattern) do
    from r in query,
    select: [:destination],
    where: fragment("? ~* ?", r.pattern, ^pattern)
  end
end
