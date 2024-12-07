defmodule Exploration.MyViewHelpers do

  def link_other_pages(page_index, projet) do
    []
    |> Enum.concat(["<div class=\"nav-prev-next-pages\">"])
    |> add_prev_page_if_exist(page_index, projet)
    |> add_next_page_if_exist(page_index, projet)
    |> Enum.concat(["</div>"])
    |> Enum.join("")
  end

  defp add_prev_page_if_exist(liste, page_index, projet) do
    if page_index > 1 do
      Enum.concat(liste, [prev_page_link(page_index, projet)])
    else
      liste
    end
  end
  defp prev_page_link(page_index, projet) do
    """
    <span class="page-prev"><a href="/explorer/#{projet}?ipage=#{page_index - 1}">← Page précédente</a></span>
    """
  end

  defp add_next_page_if_exist(liste, page_index, projet) do
    filepath = "lib/exploration_web/controllers/explorer_#{projet}/explorer_#{projet}_html/page-#{page_index + 1}.html.mmd"
    if File.exists?(filepath) do
      Enum.concat(liste, [next_page_link(page_index, projet)])
    else
      liste
    end
  end

  defp next_page_link(page_index, projet) do
    """
    <span class="page-next"><a href="/explorer/#{projet}?ipage=#{page_index + 1}">Page suivante →</a></span>
    """
  end

end