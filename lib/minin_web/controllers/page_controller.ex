defmodule MininWeb.PageController do
  use MininWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
