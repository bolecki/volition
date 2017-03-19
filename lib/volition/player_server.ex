defmodule Volition.PlayerServer do
  use GenServer
  require Logger

  defstruct [:name, health: 100, mana: 100, gold: 0, area: 2]

  def new(name) do
    character =
      Volition.Repo.get_by(Volition.Player, name: name)
      |> Volition.Repo.preload(area: :nearbys) ||
      Volition.Repo.insert!(%Volition.Player{name: name, area_id: 2, gold: 0, health: 100, mana: 100})
      |> Volition.Repo.preload(area: :nearbys)
    Logger.debug"> got char from db: #{inspect character}"
    server = %Volition.PlayerServer{name: character.name, health: character.health, mana: character.mana, gold: character.gold, area: character.area}
    Logger.debug"> created server: #{inspect server}"
    server
  end

  def handle_call(:get_player, _from, player) do
    {:reply, player, player}
  end

  def handle_cast({:set_player, player}, _state) do
    {:noreply, player}
  end
end