defmodule ExplorationWeb.ExplorerExplorationController do
  use ExplorationWeb, :controller

  def explorer(conn, params) do
    page_index  = params["ipage"] || 1
    page_index = if page_index < 10, do: "0#{page_index}", else: page_index
    render(conn, String.to_atom("page-#{page_index}"), page_title: "Exploration de « Exploration »")
  end

end