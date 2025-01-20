defmodule Exploration.MyViewHelpers do

  use Phoenix.VerifiedRoutes, 
    endpoint: ExplorationWeb.Endpoint, 
    router: ExplorationWeb.Router

  def link_other_pages(page_index, projet) do
    page_index = ensure_page_index(page_index)
    []
    |> Enum.concat(["<div class=\"nav-prev-next-pages\">"])
    |> add_prev_page_if_exist(page_index, projet)
    |> add_next_page_if_exist(page_index, projet)
    |> Enum.concat(["</div>"])
    |> Enum.join("")
  end

  defp add_prev_page_if_exist(liste, page_index, projet) do
    page_index = ensure_page_index(page_index)
    if page_index > 1 do
      Enum.concat(liste, [prev_page_link(page_index, projet)])
    else
      liste
    end
  end
  defp prev_page_link(page_index, projet) do
    page_index = ensure_page_index(page_index)
    lien = ~p"/explorer" <> "/#{projet}"
    """
    <span class="page-prev"><a href="#{lien}?ipage=#{page_index - 1}">← Page précédente</a></span>
    """
  end

  defp add_next_page_if_exist(liste, page_index, projet) do
    page_index = ensure_page_index(page_index)
    filepath = "lib/exploration_web/controllers/explorer_#{projet}/explorer_#{projet}_html/page-#{page_index + 1}.html.mmd"
    if File.exists?(filepath) do
      Enum.concat(liste, [next_page_link(page_index, projet)])
    else
      liste
    end
  end

  defp next_page_link(page_index, projet) do
    page_index = ensure_page_index(page_index)
    lien = ~p"/explorer" <> "/#{projet}"
    """
    <span class="page-next"><a href="#{lien}?ipage=#{page_index + 1}">Page suivante →</a></span>
    """
  end

  defp ensure_page_index(page_index) when is_integer(page_index), do: page_index
  defp ensure_page_index(page_index) do
    if is_integer(page_index) do
      page_index
    else
      IO.puts IO.ANSI.red() <> "Problème avec l'index de page envoyé : #{inspect page_index}. Je le corrige à 1 mais il faudra réparer." <> IO.ANSI.reset()
      1
    end
  end

end