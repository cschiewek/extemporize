defmodule Extemporize.RedirectController do
  use Extemporize.Web, :controller

  alias Extemporize.Redirect

  def index(conn, _params) do
    redirects = Repo.all(Redirect)
    render(conn, "index.html", redirects: redirects)
  end

  def new(conn, _params) do
    changeset = Redirect.changeset(%Redirect{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"redirect" => redirect_params}) do
    changeset = Redirect.changeset(%Redirect{}, redirect_params)

    case Repo.insert(changeset) do
      {:ok, _redirect} ->
        Redirect.Cache.update
        conn
        |> put_flash(:info, "Redirect created successfully.")
        |> redirect(to: redirect_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    redirect = Repo.get!(Redirect, id)
    render(conn, "show.html", redirect: redirect)
  end

  def edit(conn, %{"id" => id}) do
    redirect = Repo.get!(Redirect, id)
    changeset = Redirect.changeset(redirect)
    render(conn, "edit.html", redirect: redirect, changeset: changeset)
  end

  def update(conn, %{"id" => id, "redirect" => redirect_params}) do
    redirect = Repo.get!(Redirect, id)
    changeset = Redirect.changeset(redirect, redirect_params)

    case Repo.update(changeset) do
      {:ok, redirect} ->
        Redirect.Cache.update
        conn
        |> put_flash(:info, "Redirect updated successfully.")
        |> redirect(to: redirect_path(conn, :show, redirect))
      {:error, changeset} ->
        render(conn, "edit.html", redirect: redirect, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    redirect = Repo.get!(Redirect, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(redirect)
    Redirect.Cache.update

    conn
    |> put_flash(:info, "Redirect deleted successfully.")
    |> redirect(to: redirect_path(conn, :index))
  end

  def match(conn, %{"domain" => domain, "path" => path}) do
    redirect = Redirect.Cache.get(domain, path)
    render_match(conn, redirect)
  end

  defp render_match(conn, nil), do: send_resp(conn, 404, "")
  defp render_match(conn, redirect), do: send_resp(conn, 200, redirect.destination)

  # Return 404 if match dosen't have a path param
  def match(conn, _), do: send_resp(conn, 404, "")
end
