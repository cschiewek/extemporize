defmodule Extemporize.RedirectControllerTest do
  use Extemporize.ConnCase

  alias Extemporize.Redirect
  @valid_attrs %{domain: "localhost.com", path: "/lol", destination: "/rofl"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, redirect_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing redirects"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, redirect_path(conn, :new)
    assert html_response(conn, 200) =~ "New redirect"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, redirect_path(conn, :create), redirect: @valid_attrs
    assert redirected_to(conn) == redirect_path(conn, :index)
    assert Repo.get_by(Redirect, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, redirect_path(conn, :create), redirect: @invalid_attrs
    assert html_response(conn, 200) =~ "New redirect"
  end

  test "shows chosen resource", %{conn: conn} do
    redirect = Repo.insert! %Redirect{}
    conn = get conn, redirect_path(conn, :show, redirect)
    assert html_response(conn, 200) =~ "Show redirect"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, redirect_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    redirect = Repo.insert! %Redirect{}
    conn = get conn, redirect_path(conn, :edit, redirect)
    assert html_response(conn, 200) =~ "Edit redirect"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    redirect = Repo.insert! %Redirect{}
    conn = put conn, redirect_path(conn, :update, redirect), redirect: @valid_attrs
    assert redirected_to(conn) == redirect_path(conn, :show, redirect)
    assert Repo.get_by(Redirect, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    redirect = Repo.insert! %Redirect{}
    conn = put conn, redirect_path(conn, :update, redirect), redirect: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit redirect"
  end

  test "deletes chosen resource", %{conn: conn} do
    redirect = Repo.insert! %Redirect{}
    conn = delete conn, redirect_path(conn, :delete, redirect)
    assert redirected_to(conn) == redirect_path(conn, :index)
    refute Repo.get(Redirect, redirect.id)
  end

  test "match without a path param", %{conn: conn} do
    conn = get conn, redirect_path(conn, :match)
    assert response(conn, 404) =~ ""
  end

  test "match with an unmatched path", %{conn: conn} do
    conn = get conn, redirect_path(conn, :match, %{path: "this won't match"})
    assert response(conn, 404) =~ ""
  end

  test "match with a matching path returns the destination", %{conn: conn} do
    redirect = %Redirect{domain: "localhost.com", path: "/lol", destination: "/rofl"} |> Repo.insert!
    conn = get conn, redirect_path(conn, :match, %{domain: "localhost.com", path: "/lol"})
    assert response(conn, 200) =~ redirect.destination
  end
end
