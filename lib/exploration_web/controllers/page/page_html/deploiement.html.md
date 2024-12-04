# Déploiement

Cette page décrit tout ce que j'ai fait pour déployer cette application Phoenix/Elixir sur [alwaysdata](https://alwaysdata.com).

1. Je me connecte en SSH à mon hébergement (`ssh <uname>@ssh-<app>.alwaydata.net`)…
1. … et je crée un nouveau dossier pour cette application (`mkdir www.phoenix-exploration`).
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
      PORT=8103
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
      config :label, Label.Mailer, 
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
        url: [host: "icare.alwaysdata.net", path: "/phoenix-exploration", port: 8103],
        http: [port: 80],
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
      port = String.to_integer(System.get_env("PORT") || "8103")
      ~~~

      > Je n'ai pas repris les informations concernant le mailer, mais c'est peut-être ici qu'il faut les mettre, dans `if config_env() == :prod do`.

