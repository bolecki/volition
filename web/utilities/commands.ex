defmodule Volition.Commands do

  def command("am " <> name, socket) do
    character =
      Volition.Repo.get_by(Volition.Player, name: name)
      |> Volition.Repo.preload(area: :nearbys) ||
      Volition.Repo.insert!(%Volition.Player{name: name, area_id: 2, gold: 0, health: 100, mana: 100})
      |> Volition.Repo.preload(area: :nearbys)

    socket = Phoenix.Socket.assign(socket, :player, character)
    Phoenix.Channel.push socket, "new_msg", %{body: "you are " <> name}
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

  def command(message, socket) do
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
end
