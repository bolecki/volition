defmodule Volition.AreaController do
  use Volition.Web, :controller

  alias Volition.Area

  def index(conn, _params) do
    areas = Repo.all(Area)
    render(conn, "index.html", areas: areas)
  end

  def new(conn, _params) do
    changeset = Area.changeset(%Area{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"area" => area_params}) do
    changeset = Area.changeset(%Area{}, area_params)

    case Repo.insert(changeset) do
      {:ok, _area} ->
        conn
        |> put_flash(:info, "Area created successfully.")
        |> redirect(to: area_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    area = Repo.get!(Area, id)
    render(conn, "show.html", area: area)
  end

  def edit(conn, %{"id" => id}) do
    area = Repo.get!(Area, id)
    changeset = Area.changeset(area)
    render(conn, "edit.html", area: area, changeset: changeset)
  end

  def update(conn, %{"id" => id, "area" => area_params}) do
    area = Repo.get!(Area, id)
    changeset = Area.changeset(area, area_params)

    case Repo.update(changeset) do
      {:ok, area} ->
        conn
        |> put_flash(:info, "Area updated successfully.")
        |> redirect(to: area_path(conn, :show, area))
      {:error, changeset} ->
        render(conn, "edit.html", area: area, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    area = Repo.get!(Area, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(area)

    conn
    |> put_flash(:info, "Area deleted successfully.")
    |> redirect(to: area_path(conn, :index))
  end
end
