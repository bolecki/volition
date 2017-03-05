defmodule Volition.Commands do
  use Phoenix.Channel
  
  def command(command, socket) do
    case command do
      "am " <> name ->
        character = Volition.Repo.get_by(Volition.Player, name: name) |> Volition.Repo.preload(area: :nearbys)
        if !character do
          character = Volition.Repo.insert!(%Volition.Player{name: name, area_id: 2, gold: 0, health: 100, mana: 100}) |> Volition.Repo.preload(area: :nearbys)
        end
        socket = assign(socket, :player, character)
        push socket, "new_msg", %{body: "you are " <> name}
      "where" ->
        if socket.assigns[:player] do
          push socket, "new_msg", %{body: "you are in " <> socket.assigns[:player].area.name}
        else
          push socket, "new_msg", %{body: "to am is to place"}
        end
      "nearby" ->
        if socket.assigns[:player] do
          names = Enum.map(socket.assigns[:player].area.nearbys, fn x -> x.name end)
          msg = Enum.join(names, ", ")
          push socket, "new_msg", %{body: "you are near " <> msg}
        else
          push socket, "new_msg", %{body: "to am is to place"}
        end
      _ ->
        if socket.assigns[:player] do
          broadcast! socket, "new_msg", %{body: socket.assigns[:player].name <> ": " <> command}
        else
          broadcast! socket, "new_msg", %{body: "anonymous: " <> command}
        end
    end
    {:noreply, socket}
  end
end
