defmodule ExplorationWeb.ExplorerMarkdownController do
  use ExplorationWeb, :controller

  def explorer(conn, params) do
    page_index  = params["ipage"] || 1
    render(conn, String.to_atom("page-#{page_index}"), page_title: "Exploration de LdQ")
  end

end