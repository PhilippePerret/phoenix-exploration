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


