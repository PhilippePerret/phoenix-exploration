defmodule ExplorationWeb.PageController do
  use ExplorationWeb, :controller

  @valid_pages [
    "deploiement",
    "sigles",
    ]

  def show(conn, params) do
    page = params["page"]
    if Enum.member?(@valid_pages, page) do
      render(conn, String.to_atom(page))
    else
      render(conn, :unknown_page, page: page)
    end
  end

  def accueil(conn, _params) do
    render(conn, :accueil)
  end

end
