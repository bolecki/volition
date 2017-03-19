defmodule Volition.Commands do
  require Logger

  def command("am " <> name, socket) do
    Phoenix.Channel.push socket, "you_are", %{body: name}
    Phoenix.Channel.push socket, "new_msg", %{body: "you are " <> name}
    Phoenix.Channel.push socket, "new_place", %{body: get_player(socket).area.name}
    {:noreply, socket}
  end

  def command("where", socket) do
    Phoenix.Channel.push socket, "new_msg", %{body: "you are in " <> get_player(socket).area.name}
    {:noreply, socket}
  end

  def command("who dat", socket) do
    presence = Volition.Presence.list(socket)
    others = Enum.map(presence, fn {k, v} -> k end)
    msg = Enum.join(others, ", ")
    Logger.debug"> dat is: #{inspect presence}"
    Phoenix.Channel.push socket, "new_msg", %{body: msg}
    {:noreply, socket}
  end

  def command("nearby", socket) do
    names = Enum.map(get_player(socket).area.nearbys, fn x -> x.name end)
    msg = Enum.join(names, ", ")
    Phoenix.Channel.push socket, "new_msg", %{body: "you are near " <> msg}
    {:noreply, socket}
  end

  def command("go " <> place, socket) do
    names = Enum.map(get_player(socket).area.nearbys, fn x -> x.name end)
    if Enum.member?(names, place) do
      area = Volition.Repo.get_by(Volition.Area, name: place) |> Volition.Repo.preload(:nearbys)
      set_player(%{get_player(socket) | area: area}, socket)
      Phoenix.Channel.broadcast! socket, "new_msg", %{body: get_player(socket).name <> " is leaving for " <> place}
      Phoenix.Channel.push socket, "new_place", %{body: place}
    else
      Phoenix.Channel.push socket, "new_msg", %{body: "you are not near there!"}
    end
    {:noreply, socket}
  end

  def command(message, socket) do
    Logger.debug"> broadcasting #{inspect message}"
    Phoenix.Channel.broadcast! socket, "new_msg", %{body: get_player(socket).name <> ": " <> message}
    {:noreply, socket}
  end

  # def command("", socket) do
  #   {:noreply, socket}
  # end

  def get_player(socket) do
    GenServer.call(socket.assigns.player, :get_player)
  end

  def set_player(player, socket) do
    GenServer.cast(socket.assigns.player, {:set_player, player})
  end
end
