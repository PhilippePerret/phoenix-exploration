defmodule ExplorationWeb.ExplorerTaskerController do
  use ExplorationWeb, :controller

  @titre_general "<h1>Exploration de Phoenix avec… TASKER (__PAGE__)<br />La Todo-list la plus légère du monde !</h1>"

  def explorer(conn, params) do
    page_index  = String.to_integer(params["ipage"] || "1")
    render(conn, String.to_atom("page-#{page_index}"),
      titre: String.replace(@titre_general, ~r/__PAGE__/, "#{page_index}"),
      page_title: "Exploration Phoenix avec Tasker",
      page_index: page_index,
      projet: "tasker"
    )

  end

end