defmodule Volition.HelloController do
  use Volition.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def show(conn, params) do
    render conn, "show.html", params: params
  end
end