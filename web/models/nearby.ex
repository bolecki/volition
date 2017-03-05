defmodule Volition.Nearby do
  use Volition.Web, :model

  schema "nearbys" do
    belongs_to :area, Volition.Area
    belongs_to :nearby, Volition.Area

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> validate_required([])
  end
end
