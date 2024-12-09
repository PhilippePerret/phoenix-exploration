defmodule ExplorationWeb.ExplorerLdQController do
  use ExplorationWeb, :controller

  @titre_general "<h1>Exploration de Phoenix avec… LdQ (__PAGE__)<br />Label « Lecture de Qualité »</h1>"

  def explorer(conn, params) do
    page_index  = String.to_integer(params["ipage"] || "1")
    render(conn, String.to_atom("page-#{page_index}"), 
      titre: String.replace(@titre_general, ~r/__PAGE__/, "#{page_index}"),
      page_title: "Exploration de LdQ",
      page_index: page_index,
      projet: "ldq"
      )
  end

end