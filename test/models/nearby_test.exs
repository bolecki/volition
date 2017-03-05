defmodule Volition.NearbyTest do
  use Volition.ModelCase

  alias Volition.Nearby

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Nearby.changeset(%Nearby{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Nearby.changeset(%Nearby{}, @invalid_attrs)
    refute changeset.valid?
  end
end
