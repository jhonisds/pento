defmodule Pento.Catalog.Product.Query do
  @moduledoc """
  Module Query `Product`.
  """

  import Ecto.Query

  alias Pento.Catalog.Product
  alias Pento.Survey.Rating

  def base, do: Product

  def with_user_ratings(query \\ base(), user) do
    ratings_query = Rating.Query.preload_user(user)

    query
    |> preload(ratings: ^ratings_query)
  end
end
