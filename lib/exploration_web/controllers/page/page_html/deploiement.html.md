# Déploiement

Cette page décrit tout ce que j'ai fait pour déployer cette application Phoenix/Elixir sur [alwaysdata](https://alwaysdata.com).

1. Je me connecte en SSH à mon hébergement (`ssh <uname>@ssh-<app>.alwaydata.net`)…
1. … et je crée un nouveau dossier pour cette application (`mkdir www/phoenix-exploration`).
1. Je télécharge tous mes fichiers Phoenix dans ce dossier.
1. Dans mon tableau de bord, je crée un nouveau site :
    * à l'adresse `www.atelier-icare.net/phoenix-exploration`,
    * dans _configuration_, je choisis `Elixir`,
    * je mets en _commande_ `/home/icare/www/phoenix-exploration/_build/prod/rel/exploration/bin/exploration start`,
    * je mets en _répertoire de travail_ `www/phoenix-exploration/`,
    * en console, je joue `mix phx.gen.secret` pour obtenir une *Secret Key Base*,
    * je définis les variables d'_Environnement_ :
      ~~~
      MIX_ENV=prod
      SECRET_KEY_BASE=<ma Secret Key Base obtenue ci-dessus>
      PHX_HOST=icare.alwaysdata.net
      PORT=8101
      SMTP_USERNAME=<mon user name>
      SMTP_PASSWORD=<nom mot de passe d'administrateur>
      # DATABASE_URL=icare_exploration # pas de base
      ~~~
    * je choisis la dernière version d'Elixir (en tout cas celle avec laquelle j'ai créé cette application),
    * je valide les informations (et je reviens donc à l'onglet de mes sites).
1. Je modifie les configurations, et particulièrement celle en production :
    * Dans `config/config.exs`, à la place de :

      ~~~
      ...
      config :exploration, Exploration.Mailer, adapter: Swoosh.Adapters.Local

      ~~~

      … je mets :

      ~~~
      ...
      # Pour définir ce qui concerne les mails
      # NE PAS OUBLIER DE CHANGER LE NOM DE L'APPLICATION (:exploration ci-dessous)
      # SI CE CODE EST COPIÉ
      config :exploration, Label.Mailer, 
        adapter: Swoosh.Adapters.SMTP,
        relay: System.get_env("SMTP_SERVER"),
        username: System.get_env("SMTP_USERNAME"),
        password: System.get_env("SMTP_PASSWORD"),
        port: 587,
        ssl: false,
        auth: :always,
        no_mx_lookups: true,
        retries: 1

      ~~~

    * Dans `config/prod.exs`, à la place de :
      
      ~~~
      ...
      config :exploration, ExplorationWeb.Endpoint,
        cache_static_manifest: "priv/static/cache_manifest.json"
      ~~~

      … j'utilise :

      ~~~
      ...
      config :exploration, ExplorationWeb.Endpoint,
        url: [host: "icare.alwaysdata.net", path: "/phoenix-exploration", port: 8101],
        http: [port: 8101],
        server: true, # ajouté par Phil
        debug_errors: false, # mettre true pour voir les erreurs en production
        cache_static_manifest: "priv/static/cache_manifest.json"
      ~~~

      > Noter notamment le `path` qu'il faut adapter à l'application.
    * dans `config/runtime.exs`, à la place de :

      ~~~
      host = System.get_env("PHX_HOST") || "example.com"
      ~~~

      … je mets :

      ~~~
      host = System.get_env("PHX_HOST") || "icare.alwaysdata.net"
      ~~~

      À la plce de :

      ~~~
      port = String.to_integer(System.get_env("PORT") || "4000")
      ~~~

      … je mets :

      ~~~
      port = String.to_integer(System.get_env("PORT") || "8101")
      ~~~

      > Je n'ai pas repris les informations concernant le mailer, mais c'est peut-être ici qu'il faut les mettre, dans `if config_env() == :prod do`.
1. Il faut bien sûr actualiser tous ces fichiers sur le site distant.
1. On peut passer véritablement au déploiement :
    1. on se reconnecte en SSH s'il le faut, 
    1. on rejoint le dossier contenant le site (pour moi `cd www/phoenix-exploration/`),
    1. on joue `mix deps.get --only prod` (pour ne mettre que les dépendances utiles en production)
    1. <strike>on joue `MIX_ENV=prod mix compile`</strike> (pour compiler le site en production et créer la release)

      > ci-dessus, il y a une erreur (?) sur le site de Phoenix puisqu'ils disent de faire `mix compile` mais en fait il faut ajouter le code ci-dessous et faire une release.

    => Tout s'est bien passé, la seule alerte concernant une déprécation de `Regex.regex?/1`.

    C'est bon ! Normalement, c'est déployé…
1. Je pourrais (peut-être) jouer `MIX_ENV=prod mix phx.server` pour démarrer le site en production, mais sur Alwaysdata, je vais plutôt dans mon tableau de bord, rubrique « Sites » et je clique sur le bouton à droite pour démarrer le site d'exploration de Phoenix.
1. Et je me rends à l'adresse `https://www.atelier-icare.net/phoenix-exploration/`.

  Et ça ne fonctionne pas…

1. ChatGPT me dit d'ajouter dans `mix.exs` :

    ~~~
    def project do
      [
        ...      
        releases: [
          exploration: [ # ATTENTION NOM APP ICI
            include_executables_for: [:unix],
            applications: [runtime_tools: :permanent]
          ]
        ]
      ]
    ~~~

1. J'ajoute un `<base href={~p"/"}>` dans le `<head>` de `root.html.heex`.
1. Puis je joue `MIX_ENV=prod mix release`.

  => Et je me retrouve encore avec le même erreur, un `GET "/exploration" qui n'est pas défini, comme si l'application était lancée depuis `www.atelier-icare.net` alors qu'elle est lancée depuis `www.atelier-icare.net/exploration`.
1. J'essaie en mettant plutôt `<base href="https://www.atelier-icare.net/exploration" />` parce que, finalement, mon `<base href={~p"/"}>` est idiot s'il y a déjà un problème à ce niveau-là (mais bon, pour moi, le problème est avant donc ça ne change rien…)
  

