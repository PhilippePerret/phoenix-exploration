defmodule ExplorationWeb.PageController do
  use ExplorationWeb, :controller

  def accueil(conn, _params) do
    render(conn, :accueil)
  end
end
