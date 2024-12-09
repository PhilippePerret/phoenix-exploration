load(_entete)

## Introduction

Je vais décrire ici le développement, sous Phoenix/Elixir, de l’application web qui doit générer le label nowrap(« Lecture de Qualité ») qui a l’ambition d’offrir un peu de clarté dans le marasme de l’autoédition en créant un label permettant de distinguer le bon grain de l’ivraie et d’offrir même un classement des livres, pour leur décerner annuellement un prix.

Ce label a fait l’objet d’un premier déploiement en production, mais se contente pour le moment, à l’heure où sont écrits ces mots, d’afficher les pages de description du label.

## Développement

Dans un premier temps, on va essayer de décrire les structures Elixir minimales qui sont nécessaire pour gérer ce label.

Une première liste des éléments indispensables qui forment la base du label :

* **les Livres**.  Ils sont au cœur du processus puisque c’est pour eux que ce label va être créé. Les deux propriétés propres au label seront :
  * **Label**. Le label attribué (pour le moment il n’existe que le label « Lecture de Qualité » mais d’autres pourraient être imaginés. C’est une structure complexe qui contiendra la date d’attribution, etc.
  * **Classement**. Le classement si le livre a la chance d’être classé. C’est une structure complexe qui peut définir plusieurs classements (général, par genre, par caractéristiques, etc.)
* **Le Comité de lecture**. C’est le groupe des lecteurs (un groupe le plus important possible, qui devrait grossir de jour en jour) qui va permettre l’attribution du label et le classement des livres. Ce comité est un ensemble de :
  * **Membre du comité** (`Committee Member`). Pour les lectrices et les lecteurs qui appartiennent à ce comité et estiment les livres. Le nom complet pourrait être « Membre du comité d’attribution du label Lecture de Qualité ».
* **Les lecteurs**. C’est pour eux que le label existe ainsi que le classement, ce sont les lecteurs et lectrices quelconques, qui peuvent s’inscrire sur le site et bénéficient dans ce cas de certains avantages (être informé des décisions, pouvoir apporter eux aussi leur avis, etc.). Ils ne sont pas à confondre bien sûr avec les lectrices et lecteur du comité, qui eux évaluent les livres.
* **Les Administrateurs**. Ce sont les personnes qui gèrent le site, les membres du comité, les pages, avec différents privilèges et différents rôles.

J’ajouterais également les textes, que j’ai envie de consigner, au format markdown, dans la base de données.

* **Les Textes**. L’ensemble des textes, grands ou petits, utiles au site. Je les mets en table pour qu’ils soient accessibles de n’importe où, sans avoir à afficher une page en particulier.

<strike>Pour le **markdown** je vais utiliser le [Markdown Template Engine](https://hexdocs.pm/phoenix_markdown/readme.html). et donc commencer à ajouter `{:phoenix_markdown, "~> 1.0"}` à `config/config.exs`. </strike>

Pour le **markdown**, je vais utiliser directement **Earmark** car Markdown Template Engine fonctionne avec des templates alors que je veux mettre le code dans une table. J’ajoute donc : ` {:earmark, "~> 1.4"},`  dans `mix.exs` (et je retire la dépendance précédente.

Mais ne nous précipitons pas, il faut en tout premier lieu que je crée l’application depuis zéro.

### Création de l’application Phoenix

Je me place donc dans mon dossier `<home>/Programmes/Phoenix/LdQ/` et je tape :

~~~elixir
mix phx.new ldq --binary-id --module LdQ
~~~

> `--binary-id` fera que tous les identifiants seront binaires.

Je renomme mon dossier `ldq-v1` , ce que j’aurais pu faire ci-dessus, en ajoutant `--app ldq` pour que l’application reste `ldq` qui, bien entendu, signifie <span style="white-space:nowrap;">« Lecture de Qualité »</span>.

J’ajoute la dépendance pour markdown et je `mix deps.get` et j’ajoute dans `config/config.exs` : 

~~~elixir
# in mix.exs
{:phoenix_markdown, "~> 1.0"}

# in config/config.ex
config :phoenix, 
	:template_engines, 
	md: PhoenixMarkdown.Engine

~~~

Il faut que je `mix ecto.create` pour crée ma **BASE DE DONNÉES** qui va s’appeler, pour le développement `LdQ_dev`. 

Je peux maintenant `mix phx.server` pour lancer le serveur et consulter la page d’accueil en cliquant avant Cmd pressée sur l’adresse donnée en réponse du lancement du serveur dans VC Studio.

Et ma page d’accueil classique de Phoenix s’affiche bien à l’adresse path(http://localhost:8000).

Comme je ne connais pas du tout ce module, je vais tenter de remplacer la page d’accueil par une page markdown, au moins pour le contenu intérieur.

Pour ça, je vais créer ma table `textes` avec un module `LdQ.Textes` qui la gèrera. Je pense que je vais faire juste un schéma pour le moment pour générer tout ça, donc je vais jouer :

~~~elixir
mix phx.gen.schema Contenu.Texte textes titre contenu:text
~~~

Ces textes seront suivis avec une table de suivi (qui permettra de savoir si la page a été corrigée, quelle version c’est, etc. :

~~~elixir
mix phx.gen.schema Contenu.SuiviTexte suivi_textes \
	main_version:integer minor_version:integer note:text \
	modified_at:naive_datetime validated_at:naive_datetime \
	texte_id:references:textes
~~~

Je vais transformer le schéma de `contenu/suivi_texte.ex` pour avoir :

~~~elixir
 belongs_to :texte, Texte, type: :binary_id
~~~

… et dans le changeset j’ajoute la ligne suivante pour obliger à avoir un texte quand on utilise une fichier de suivi de texte.

~~~elixir
|> assoc_constraint(:texte)
~~~

Je vais créer un premier texte, par le seed, pour l’accueil.

~~~elixir
# in priv/repo/seeds.exs

alias LdQ.Repo

alias LdQ.Contenu.Texte
alias LdQ.Contenu.SuiviTexte

bienvenue = Repo.insert!(%Texte{
	id: "home_message_accueil",
	titre: "Message d'accueil général",
	contenu: "Bienvenue sur le site du label _LECTURE_DE_QUALITE_"
})

Repo.insert!(%SuiviTexte{
	texte: bienvenue,
	main_version: 0,
	minor_version: 1,
	validated_at: ~N"2024-11-30 15:11:00"
	note: "La toute première version du texte d'accueil."
})

~~~

Et, après avoir arrêté le serveur, je joue les migrations…

~~~elixir
mix ecto.migrate
~~~

… et les graines

~~~elixir
mix run priv/repo/seeds.exs
~~~

… et après avoir corrigé les erreurs (que j’ai corrigées aussi ci-dessus), le premier texte avec sa fiche de suivi a été enregistré.

Je vais essayer de le récupérer pour ma page d’accueil, en consultant d’abord la documentation de la dépendance.

…

Dans `config.exs` j’ajoute la ligne suivante, je pense pour pouvoir avoir des `<%= ... %>` dans le code markdown.

~~~elixir
config :phoenix_markdown, :server_tags, :all
~~~

### Module Contenu

Je vais maintenant faire à la main le module `Contenu` qui doit me permettre de gérer les textes. En m’inspirant de l’exploration que j’ai faite avec *Tasker*, Je crée le fichier :

~~~elixir
# in lib/ldq/contenu.ex

defmodule LdQ.Contenu do

	import Ecto.Query, warn: false
	
	alias LdQ.Contenu.Texte
	alias LdQ.Contenu.SuiviTexte

	@doc """
	Pour charger juste le texte et le titre
	"""
	def	get_texte!(id) do
		Repo.get!(Texte, id)
	end
	
	@doc """
	Pour charger le texte, le titre et toutes les
	informations sur sa création et son suivi.
	"""
	def get_full_texte(!id) do
		Repo.get!(Texte,id)
		|> Repo.preload(:suivi_texte)
	end
end
~~~

Mais alors que je le crée, je réalise que mon identifiant pour les textes n’est pas pertinent. Il faut que j’ai quelque chose de fixe pour pouvoir y faire appel. Il faut que je remplace `id` au format `binaire` par un identifiant `string` qui permettra de charger le texte qu’on désire.

Je modifie donc les migrations et les schémas.

~~~elixir
mix ecto.drop
~~~

~~~elixir
add :id, :string, primary_key: true
~~~

Je dois mettre ça dans le schéma de `Contenu.Texte` :

~~~elixir
@primary_key {:id, :string, autogenerate: false}
~~~

### Définition de la page d’accueil

Je vais tenter de mettre ce message d’accueil sur ma page d’accueil. D’abord, je vide complètement la page d’accueil par défaut `controllers/page_html/home.html.heex` en y mettant :

~~~html
<.flash_group flash={@flash} />

[PAGE D'ACCUEIL DU LABEL]
~~~

Et j’y ajoute mon message d’accueil déjà enregistré en markdown :

~~~html
<.flash_group flash={@flash} />

[PAGE D'ACCUEIL DU LABEL]

<%= raw @message_accueil %>
~~~

Dans le contrôleur, je vais ajouter la définition du message :

~~~elixir
# in controllers/page_controller.ex

def home(conn, _params) do
  render(conn, :home, message: message_accueil(conn))
end

defp message_accueil(_conn) do
  texte = Contenu.get_texte!("home_welcome_message")
  Earmark.as_html!(texte.contenu)
end

~~~

J’ai galéré un peu pour obtenir ce résultat, mais finalement ça fonctionne ! 🥳

Je vais modifier un peu le root pour avoir un entête qui correspondra à l’entête du site.

Et d’ores et déjà je compte faire des essais avec *Earmark* pour voir s’il peut gérer les `<%= ... %>` comme le fait l’engin Markdown que je ne veux pas utiliser. Je vais faire une méthode générique qui récupère un message et le transforme en HTML :

> La suite n'est plus pertinente puisque j'ai entretemps créer l'extension `pp_markdown` qui me permet d'utiliser des fichiers p(.mmd) qui sont traités en profondeur.

~~~elixir
def markdownize_dbtexte(texte_id, _conn) do
  texte = Contenu.get_texte!("home_welcome_message")
  options = %Earmark.Options{
  	gfm: true,
  	# server_tags: :all # NE FONCTIONNE PAS
  }
  Earmark.as_html!(texte.contenu, options)
end

end
~~~

Sur le fait que `server_tags` ne fonctionne pas, on verra comment envoyer des variables si c’est nécessaire.

### Page de présentation du label

Finalement, je décide d’avoir une partie, présentant le label, qui soit séparée et contienne toutes les pages markdown. Ce sera la partie « overview » (aperçu) du site, qui sera plus qu’un aperçu puisqu’on y écrira précisément le label.

Toute cette partie sera atteinte par p(/presentation) et sera contrôlée par le contrôleur `OverviewController` et donc  `OverviewHTML` avec les pages markdown dans p(controllers/overview_html/).

Mon contrôleur est défini ainsi : 

~~~elixir
# in controllers/overview_controller.ex

defmodule LdQWeb.OverviewController do
  use LdQWeb, :controller

  def portail(conn, _params) do
    render(conn, :portail, %{})
  end

end

~~~

Le serveur de page HTML : 

~~~elixir
# in controllers/overview_html.ex

defmodule LdQWeb.OverviewHTML do
  @moduledoc """
  This module contains pages rendered by OverviewController.

  See the `overview_html` directory for all templates available.
  """
  use LdQWeb, :html

  embed_templates "overview_html/*"
end

~~~

Pour la route : 

~~~elixir
# in router.ex

  scope "/presentation", LdQWeb do
    pipe_through :browser

    get "/", OverviewController, :portail
  end

~~~

Et je vais aller rechercher dans l’application que j’ai amorcée les pages déjà écrites et construites.

load(_pied_de_page)
