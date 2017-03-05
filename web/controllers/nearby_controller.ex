defmodule Volition.NearbyController do
  use Volition.Web, :controller

  alias Volition.Nearby

  def index(conn, _params) do
    nearbys = Repo.all(Nearby)
    render(conn, "index.html", nearbys: nearbys)
  end

  def new(conn, _params) do
    changeset = Nearby.changeset(%Nearby{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"nearby" => nearby_params}) do
    changeset = Nearby.changeset(%Nearby{}, nearby_params)

    case Repo.insert(changeset) do
      {:ok, _nearby} ->
        conn
        |> put_flash(:info, "Nearby created successfully.")
        |> redirect(to: nearby_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    nearby = Repo.get!(Nearby, id)
    render(conn, "show.html", nearby: nearby)
  end

  def edit(conn, %{"id" => id}) do
    nearby = Repo.get!(Nearby, id)
    changeset = Nearby.changeset(nearby)
    render(conn, "edit.html", nearby: nearby, changeset: changeset)
  end

  def update(conn, %{"id" => id, "nearby" => nearby_params}) do
    nearby = Repo.get!(Nearby, id)
    changeset = Nearby.changeset(nearby, nearby_params)

    case Repo.update(changeset) do
      {:ok, nearby} ->
        conn
        |> put_flash(:info, "Nearby updated successfully.")
        |> redirect(to: nearby_path(conn, :show, nearby))
      {:error, changeset} ->
        render(conn, "edit.html", nearby: nearby, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    nearby = Repo.get!(Nearby, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(nearby)

    conn
    |> put_flash(:info, "Nearby deleted successfully.")
    |> redirect(to: nearby_path(conn, :index))
  end
end
