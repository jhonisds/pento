defmodule Pento.Catalog.Product do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias Pento.Survey.Rating

  schema "products" do
    field :description, :string
    field :name, :string
    field :sku, :integer
    field :unit_price, :float
    field :image_upload, :string

    has_many :ratings, Rating

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :unit_price, :sku, :image_upload])
    |> validate_required([:name, :description, :unit_price, :sku])
    |> validate_number(:unit_price, greater_than: 0)
    |> unique_constraint(:sku)
  end
end
