defmodule Volition.NearbyControllerTest do
  use Volition.ConnCase

  alias Volition.Nearby
  @valid_attrs %{}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, nearby_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing nearbys"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, nearby_path(conn, :new)
    assert html_response(conn, 200) =~ "New nearby"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, nearby_path(conn, :create), nearby: @valid_attrs
    assert redirected_to(conn) == nearby_path(conn, :index)
    assert Repo.get_by(Nearby, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, nearby_path(conn, :create), nearby: @invalid_attrs
    assert html_response(conn, 200) =~ "New nearby"
  end

  test "shows chosen resource", %{conn: conn} do
    nearby = Repo.insert! %Nearby{}
    conn = get conn, nearby_path(conn, :show, nearby)
    assert html_response(conn, 200) =~ "Show nearby"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, nearby_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    nearby = Repo.insert! %Nearby{}
    conn = get conn, nearby_path(conn, :edit, nearby)
    assert html_response(conn, 200) =~ "Edit nearby"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    nearby = Repo.insert! %Nearby{}
    conn = put conn, nearby_path(conn, :update, nearby), nearby: @valid_attrs
    assert redirected_to(conn) == nearby_path(conn, :show, nearby)
    assert Repo.get_by(Nearby, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    nearby = Repo.insert! %Nearby{}
    conn = put conn, nearby_path(conn, :update, nearby), nearby: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit nearby"
  end

  test "deletes chosen resource", %{conn: conn} do
    nearby = Repo.insert! %Nearby{}
    conn = delete conn, nearby_path(conn, :delete, nearby)
    assert redirected_to(conn) == nearby_path(conn, :index)
    refute Repo.get(Nearby, nearby.id)
  end
end
