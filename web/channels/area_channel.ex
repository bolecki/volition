defmodule Volition.AreaChannel do
  use Phoenix.Channel
  require Logger

  intercept ["new_msg", "presence_diff"]

  def join("area:" <> _area_id, _message, socket) do
    send(self(), :after_join)
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    push socket, "presence_state", Volition.Presence.list(socket)
    player = GenServer.call(socket.assigns.player, :get_player)
    Volition.Presence.track(socket, player.name, %{
      updated: :os.system_time(:milli_seconds)
    })
    {:noreply, socket}
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    player = GenServer.call(socket.assigns.player, :get_player)
    Logger.debug"> got message from: #{inspect player.name}"
    Logger.debug"> new_msg #{inspect body}"
    Volition.Commands.command body, socket
  end

  def handle_in("create", %{"body" => body}, socket) do
    if body["type"] == "area" do
      if body["description"] && body["history"] && body["name"] do
        Volition.Repo.insert(%Volition.Area{name: body["name"], description: body["description"], history: body["history"]})
      end
      broadcast! socket, "new_msg", %{body: "got an area!"}
    else
      broadcast! socket, "new_msg", %{body: body["type"]}
    end
    {:noreply, socket}
  end

  def handle_out("new_msg", payload, socket) do
    push socket, "new_msg", payload
    {:noreply, socket}
  end

  def handle_out("presence_diff", _payload, socket) do
    player = GenServer.call(socket.assigns.player, :get_player)
    Volition.Presence.track(socket, player.name, %{
      updated: :os.system_time(:milli_seconds)
    })
    {:noreply, socket}
  end

  def leave(_reason, socket) do
    player = GenServer.call(socket.assigns.player, :get_player)
    Logger.debug "Socket: #{inspect(player.name)} leaving"
    {:ok, socket}
  end

  def terminate(reason, socket) do
    Logger.debug"> leave #{inspect reason}"
    player = GenServer.call(socket.assigns.player, :get_player)
    character = Volition.Repo.get_by(Volition.Player, name: player.name)
    changeset = Ecto.Changeset.change(character, %{
      health: player.health,
      mana: player.mana,
      gold: player.gold,
      area_id: player.area.id
    })
    Volition.Repo.update(changeset)
    Logger.debug"> updated character"
    {:ok, socket}
  end
end
