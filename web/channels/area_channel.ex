defmodule Volition.AreaChannel do
  use Phoenix.Channel

  intercept ["new_msg"]

  def join("area:" <> _area_id, _message, socket) do
    {:ok, socket}
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
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
end
