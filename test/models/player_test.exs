defmodule Volition.PlayerTest do
  use Volition.ModelCase

  alias Volition.Player

  @valid_attrs %{gold: 42, health: 42, mana: 42, name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Player.changeset(%Player{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Player.changeset(%Player{}, @invalid_attrs)
    refute changeset.valid?
  end
end
