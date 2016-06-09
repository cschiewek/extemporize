defmodule Extemporize.RedirectTest do
  use Extemporize.ModelCase

  alias Extemporize.Redirect

  @valid_attrs %{destination: "some content", pattern: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Redirect.changeset(%Redirect{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Redirect.changeset(%Redirect{}, @invalid_attrs)
    refute changeset.valid?
  end
end
