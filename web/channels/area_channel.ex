defmodule Volition.AreaChannel do
  use Phoenix.Channel
  require Logger

  intercept ["new_msg"]

  def join("area:" <> _area_id, _message, socket) do
    {:ok, socket}
  end

  def handle_in("new_msg", %{"body" => body, "user" => user}, socket) do
    socket = check_user user, socket
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

  def leave(_reason, socket) do
    Logger.debug "Socket: #{inspect(socket.assigns[:player].name)} leaving"
    {:ok, socket}
  end

  def terminate(reason, socket) do
    Logger.debug"> leave #{inspect reason}"
    {:ok, socket}
  end

  def check_user(user, socket) do
    if socket.assigns[:player] do
      if user == socket.assigns[:player].name do
        Logger.debug"> socket already #{inspect user}"
        socket
      else
        Logger.debug"> user changing from #{inspect socket.assigns[:player].name} to #{inspect user}"
        Volition.Commands.assign_user user, socket
      end
    else
      if user == "anonymous" do
        Logger.debug"> user anonymous"
        socket
      else
        Logger.debug"> user new #{inspect user}"
        Volition.Commands.assign_user user, socket
      end
    end
  end
end
