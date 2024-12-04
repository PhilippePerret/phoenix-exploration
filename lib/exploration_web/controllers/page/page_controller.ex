defmodule ExplorationWeb.PageController do
  use ExplorationWeb, :controller

  def show(conn, params) do
    page = params["page"]
    render(conn, String.to_atom(page))
  end

  def accueil(conn, _params) do
    render(conn, :accueil)
  end
end
