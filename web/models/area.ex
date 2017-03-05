defmodule Volition.Area do
  use Volition.Web, :model

  schema "areas" do
    field :name, :string
    field :description, :string
    field :history, :string
    has_many :_nearbys, Volition.Nearby
    has_many :nearbys, through: [:_nearbys, :nearby]

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
