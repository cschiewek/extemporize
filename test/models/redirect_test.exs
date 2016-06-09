defmodule Extemporize.RedirectTest do
  use Extemporize.ModelCase

  alias Extemporize.Redirect

  @valid_attrs %{destination: "some content", pattern: "some content"}
  @invalid_attrs %{destination: " ", pattern: " "}

  test "attributes exist" do
    for attr <- [:destination, :pattern], do: assert %Redirect{} |> Map.keys |> Enum.member?(attr)
  end

  test "changeset with valid attributes" do
    changeset = Redirect.changeset(%Redirect{}, @valid_attrs)
    assert changeset.valid?
  end

  test "string fields gets whitespace stripped" do
    for attr <- [:pattern, :destination] do
      value = Map.get(@valid_attrs, attr) <> " "
      changeset = Redirect.changeset(%Redirect{}, Map.put(@valid_attrs, attr, value))
      assert changeset |> Map.get(:changes) |> Map.get(attr) == Map.get(@valid_attrs, attr)
    end
  end

  test "changeset without required fields" do
    for attr <- [:destination, :pattern] do
      changeset = Redirect.changeset(%Redirect{}, Map.delete(@valid_attrs, attr))
      refute changeset.valid?
    end
  end

  test "changeset with duplicate pattern" do
    Repo.insert! Redirect.changeset(%Redirect{}, @valid_attrs)
    {result, _} = Repo.insert Redirect.changeset(%Redirect{}, @valid_attrs)
    assert result == :error
  end

  test "match query is correct" do
    inserted = Repo.insert! Redirect.changeset(%Redirect{}, @valid_attrs)
    result = Redirect.match("some content") |> Repo.one
    assert result.destination == inserted.destination
  end
end
