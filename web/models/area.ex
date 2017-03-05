defmodule Volition.Area do
  use Volition.Web, :model

  schema "areas" do
    field :name, :string
    field :description, :string
    field :history, :string
    many_to_many :nearbys, Volition.Area, join_through: Volition.Nearby, join_keys: [area_id: :id, nearby_id: :id]

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description, :history])
    |> validate_required([:name, :description, :history])
  end
end
