# Déploiement

Cette page décrit tout ce que j'ai fait pour déployer cette application Phoenix/Elixir sur [alwaysdata](https://alwaysdata.com).

1. J'ai commencé par télécharger tous mes fichiers dans un dossier dédié.

1. Dans mon tableau de bord, je crée un nouveau site :
  * à l'adresse `www.atelier-icare.net/phoenix-exploration`,
  * dans configuration, je choisis `Elixir`,
  * je mets en commande `/home/icare/www/phoenix-exploration/_build/prod/rel/exploration/bin/exploration start`,
  * je mets en répertoire de travail `www/phoenix-exploration/`,
  * je joue `mix phx.gen.secret` pour obtenir une *Secret Key Base*,
  * je définis les variables d'environnement :
    ~~~
    MIX_ENV=prod
    SECRET_KEY_BASE=<ma Secret Key Base obtenue ci-dessus>
    DATABASE_URL=icare_ldq_label
    PHX_HOST=icare.alwaysdata.net
    PORT=8103
    SMTP_USERNAME=<mon user name>
    SMTP_PASSWORD=<nom mot de passe d'administrateur>
    ~~~
  * je choisis la dernière version d'Elixir (en tout cas celle avec laquelle j'ai créé cette application),
  * je valide les informations (et je reviens donc à l'onglet de mes sites).


