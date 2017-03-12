defmodule Volition.Commands do
  require Logger

  def command("am " <> name, socket) do
    socket = assign_user(name, socket)
    Phoenix.Channel.push socket, "you_are", %{body: name}
    Phoenix.Channel.push socket, "new_msg", %{body: "you are " <> name}
    Phoenix.Channel.push socket, "new_place", %{body: socket.assigns[:player].area.name}
    {:noreply, socket}
  end

  def command("where", socket) do
    if socket.assigns[:player] do
      Phoenix.Channel.push socket, "new_msg", %{body: "you are in " <> socket.assigns[:player].area.name}
    else
      Phoenix.Channel.push socket, "new_msg", %{body: "to am is to place"}
    end
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
    if socket.assigns[:player] do
      names = Enum.map(socket.assigns[:player].area.nearbys, fn x -> x.name end)
      msg = Enum.join(names, ", ")
      Phoenix.Channel.push socket, "new_msg", %{body: "you are near " <> msg}
    else
      Phoenix.Channel.push socket, "new_msg", %{body: "to am is to place"}
    end
    {:noreply, socket}
  end

  def command("go " <> place, socket) do
    if socket.assigns[:player] do
      names = Enum.map(socket.assigns[:player].area.nearbys, fn x -> x.name end)
      if Enum.member?(names, place) do
        Phoenix.Channel.broadcast! socket, "new_msg", %{body: socket.assigns[:player].name <> " is leaving for " <> place}
        Phoenix.Channel.push socket, "new_place", %{body: place}
      else
        Phoenix.Channel.push socket, "new_msg", %{body: "you are not near there!"}
      end
    else
      Phoenix.Channel.push socket, "new_msg", %{body: "to am is to place"}
    end
    area_id = Volition.Repo.get_by(Volition.Area, name: place).id
    changeset = Ecto.Changeset.change(socket.assigns[:player], %{area_id: area_id})
    Volition.Repo.update(changeset)
    character =
      Volition.Repo.get_by(Volition.Player, name: socket.assigns[:player].name)
      |> Volition.Repo.preload(area: :nearbys)
    socket = Phoenix.Socket.assign(socket, :player, character)
    {:noreply, socket}
  end

  def command(message, socket) do
    Logger.debug"> broadcasting #{inspect message}"
    if socket.assigns[:player] do
      Phoenix.Channel.broadcast! socket, "new_msg", %{body: socket.assigns[:player].name <> ": " <> message}
    else
      Phoenix.Channel.broadcast! socket, "new_msg", %{body: "anonymous: " <> message}
    end
    {:noreply, socket}
  end

  # def command("", socket) do
  #   {:noreply, socket}
  # end

  def assign_user(name, socket) do
    character =
      Volition.Repo.get_by(Volition.Player, name: name)
      |> Volition.Repo.preload(area: :nearbys) ||
      Volition.Repo.insert!(%Volition.Player{name: name, area_id: 2, gold: 0, health: 100, mana: 100})
      |> Volition.Repo.preload(area: :nearbys)

    Phoenix.Socket.assign(socket, :player, character)
  end
end
