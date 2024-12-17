# Bienvenue !

Sur ce site, je partage mon exploration du [framework Phoenix/Elixir](https://www.phoenixframework.org). Il est né de l'envie de partager de façon bien sûr, mais aussi de palier l'absence presque totale de documentation ou d'aide sur le framework dans la langue de [Molière](https://fr.wikipedia.org/wiki/Molière).

Voilà ce que vous pouvez y trouver :

[Application TASKER, première exploration](<%= ~p"/explorer/tasker" %>):
:C'est une toute première exploration, par la fabrication d'une première application complète, _TASKER_, après avoir feuilleté pas mal de documentation (mais je reviens sur tous les points). Quelques tables.
:Sujets : découverte de du framework Phoenix, tables avec association, algorithme de tri.

[Application web LECTURE DE QUALITÉ, deuxième exploration](<%= ~p"/explorer/ldq" %>):
:Seconde exploration, mais presque en parallèle de la précédente, d'une application grandeur nature. Beaucoup de tables jointes, traitement des mails, traitement des connexions nombreuses, nombreux algorithmes.
:Sujets : traitement des rôles (users), gettext.

[Package MARKDOWN](<%= ~p"/explorer/markdown" %>):
:Cette quatrième application s'intéresse particulièrement à la fabrication d'une dépendance, ici pour améliorer la dépendence _phoenix-markdown_.
: Sujets : moteur de rendu (markdown), tests, [problème de chemin](<%= (~p"/explorer") <> "/markdown/?ipage=4#problemeroute" %>), [expressions régulière](<%= (~p"/explorer") <> "/markdown/?ipage=5" %>).

[Application EXPLORATION](<%= ~p"/explorer/exploration" %>):
:En fait, c'est ce site, qui me permet de tester profondément le déploiement de Phoenix (particulièrement sur l'hébergement Alwaysdata).

[AIDE AU DÉPLOIEMENT](<%= ~p"/deploiement" %>):
:Sert de feuille de mémoire pour réussir rapidement son déploiement sur l'hébergeur Alwaysdata.
:Sujets : déploiement (sur Alwaysdata), actualisation du site.

## Découverte et installation de Phoenix/Elixir

Il existe une documentation complète en anglais sur l'installation et les premiers pas avec Phoenix/Elixir, mais en français, je vous recommande le [site de Julien Rollin](https://www.julienrollin.com/posts/decouverte-du-langage-langage-elixir-et-du-framework-phoenix/) qui fait un très bon tour d'horizon du framework et la façon de l'installer.