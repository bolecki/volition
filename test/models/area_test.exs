defmodule Volition.AreaTest do
  use Volition.ModelCase

  alias Volition.Area

  @valid_attrs %{description: "some content", history: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Area.changeset(%Area{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Area.changeset(%Area{}, @invalid_attrs)
    refute changeset.valid?
  end
end
