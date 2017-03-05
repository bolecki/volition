defmodule Volition.AreaControllerTest do
  use Volition.ConnCase

  alias Volition.Area
  @valid_attrs %{description: "some content", history: "some content", name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, area_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing areas"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, area_path(conn, :new)
    assert html_response(conn, 200) =~ "New area"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, area_path(conn, :create), area: @valid_attrs
    assert redirected_to(conn) == area_path(conn, :index)
    assert Repo.get_by(Area, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, area_path(conn, :create), area: @invalid_attrs
    assert html_response(conn, 200) =~ "New area"
  end

  test "shows chosen resource", %{conn: conn} do
    area = Repo.insert! %Area{}
    conn = get conn, area_path(conn, :show, area)
    assert html_response(conn, 200) =~ "Show area"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, area_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    area = Repo.insert! %Area{}
    conn = get conn, area_path(conn, :edit, area)
    assert html_response(conn, 200) =~ "Edit area"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    area = Repo.insert! %Area{}
    conn = put conn, area_path(conn, :update, area), area: @valid_attrs
    assert redirected_to(conn) == area_path(conn, :show, area)
    assert Repo.get_by(Area, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    area = Repo.insert! %Area{}
    conn = put conn, area_path(conn, :update, area), area: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit area"
  end

  test "deletes chosen resource", %{conn: conn} do
    area = Repo.insert! %Area{}
    conn = delete conn, area_path(conn, :delete, area)
    assert redirected_to(conn) == area_path(conn, :index)
    refute Repo.get(Area, area.id)
  end
end
