defmodule Pharkdown.Helpers do

  def path(chemin) do
    ~s(<code>#{chemin}</code>)
  end

  def compile(x, y) do
    ~s(Je ne sais plus compiler #{inspect x} et #{inspect y})
  end

end