defmodule Mix.Tasks.Volition.Loader do
  use Mix.Task
  require Logger

  @shortdoc "Load areas if not existing"

  def run(_args) do
    Mix.shell.info "Checking to see if areas are already loaded..."
    [:postgrex, :ecto] |> Enum.each(&Application.ensure_all_started/1)
    Volition.Repo.start_link
    Mix.shell.info "Started repo..."
    if Volition.Repo.get(Volition.Area, 1) do
      Mix.shell.info "Already loaded!"
    else
      Mix.shell.info "Not loaded: loading now..."
      load_areas()
    end
  end

  def load_areas() do
    {:ok, json} = File.read("areas.json")
    data = Poison.decode!(json)
    Logger.debug"> #{inspect data}"
    store_area data["areas"]
    create_nearby data["areas"]
  end

  def store_area([area | tail]) do
    name = area["name"]
    Logger.debug"> adding: #{inspect name}"

    Volition.Repo.insert(%Volition.Area{
      name: area["name"],
      description: area["description"],
      history: area["history"]
    })

    store_area tail
  end

  def store_area([]) do
    Logger.debug"> added all areas"
  end

  def create_nearby([area | tail]) do
    location = Volition.Repo.get_by(Volition.Area, name: area["name"]) |> Volition.Repo.preload(:nearbys)
    nearby = for n <- area["nearby"], do: Volition.Repo.get_by(Volition.Area, name: n)
    changeset = Ecto.Changeset.change(location) |> Ecto.Changeset.put_assoc(:nearbys, nearby)
    Volition.Repo.update(changeset)

    create_nearby tail
  end

  def create_nearby([]) do
    Logger.debug"> added all nearby"
  end
end