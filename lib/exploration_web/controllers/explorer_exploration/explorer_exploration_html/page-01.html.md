# Exploration de EXPLORATION

_EXPLORATION_, c'est en fait ce site internet. Cette partie concerne donc l'exploration de Phoenix par le biais de cette auto-exploration.

La première difficulté rencontrée pour faire ce site — et toujours pas résolue —, c'est que je voulais un système assez simple, avec un contrôleur unique (`ExplorerController`) qui en fonction de l'application chargeait les vues depuis différents fichiers. Je n'ai pas encore réussi (alors que ça doit être simplissime…)

Je veux utiliser ces routes :

~~~
/explorer/tasker    # pour explorer le développement de TASKER
/explorer/markdonw  # idem avec le package Markdown
/explorer/ldq       # idem pour le label de qualité
/explorer/<n'importe quelle application>
~~~

Avec un router de cette forme :

~~~
scope "/explorer", ExplorationWeb do
  get "/:app", ExplorerController, :explorer
~~~

Et la fonction :

~~~
defmodule ExplorationWeb.ExplorerController do
  user ExplorationWeb, :controller

  def explorer(conn, params) do
    page_index  = params["ipage"] || 1
    application = params["app"]
    render(...)
  end
~~~
