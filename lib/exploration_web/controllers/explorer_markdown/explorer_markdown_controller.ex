defmodule ExplorationWeb.ExplorerMarkdownController do
  use ExplorationWeb, :controller

  @titre_general "<h1>Exploration de Phoenix avec… MARKDOWN (__PAGE__)<br />Création d’un package pour Phoenix/elixir</h1>"

  def explorer(conn, params) do
    page_index  = String.to_integer(params["ipage"] || "1")
    render(conn, String.to_atom("page-#{page_index}"),
      titre: String.replace(@titre_general, ~r/__PAGE__/, "#{page_index}"),
      page_title: "Exploration de phoenix avec LdQ",
      page_index: page_index,
      projet: "markdown"
    )
  end

end