defmodule Extemporize.RedirectTest do
  use Extemporize.ModelCase

  alias Extemporize.Redirect

  @valid_attrs %{domain: "localhost.com", path: "/lol", destination: "/rofl"}
  @invalid_attrs %{domain: " ", destination: " ", path: " "}

  test "attributes exist" do
    for attr <- [:domain, :destination, :path], do: assert %Redirect{} |> Map.keys |> Enum.member?(attr)
  end

  test "changeset with valid attributes" do
    changeset = Redirect.changeset(%Redirect{}, @valid_attrs)
    assert changeset.valid?
  end

  test "string fields gets whitespace stripped" do
    for attr <- [:domain, :path, :destination] do
      value = Map.get(@valid_attrs, attr) <> " "
      changeset = Redirect.changeset(%Redirect{}, Map.put(@valid_attrs, attr, value))
      assert changeset |> Map.get(:changes) |> Map.get(attr) == Map.get(@valid_attrs, attr)
    end
  end

  test "changeset without required fields" do
    for attr <- [:domain, :destination, :path] do
      changeset = Redirect.changeset(%Redirect{}, Map.delete(@valid_attrs, attr))
      refute changeset.valid?
    end
  end

  test "changeset with duplicate path" do
    Repo.insert! Redirect.changeset(%Redirect{}, @valid_attrs)
    {result, _} = Repo.insert Redirect.changeset(%Redirect{}, @valid_attrs)
    assert result == :error
  end

  test "match query is correct" do
    inserted = Repo.insert! Redirect.changeset(%Redirect{}, @valid_attrs)
    result = Redirect.match("localhost.com", "/lol") |> Repo.one
    assert result.destination == inserted.destination
  end
end
