defmodule Volition.GameController do
  use Volition.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end