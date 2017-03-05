defmodule Volition.Player do
  use Volition.Web, :model

  schema "players" do
    field :name, :string
    field :gold, :integer
    field :health, :integer
    field :mana, :integer
    belongs_to :area, Volition.Area

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :gold, :health, :mana])
    |> validate_required([:name, :gold, :health, :mana])
  end
end
