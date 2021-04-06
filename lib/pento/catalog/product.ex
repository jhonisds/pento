defmodule Pento.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :description, :string
    field :name, :string
    field :sku, :integer
    field :unique_price, :float

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :unique_price, :sku])
    |> validate_required([:name, :description, :unique_price, :sku])
    |> unique_constraint(:sku)
    |> validate_number(:unique_price, greater_than: 0.0)
  end
end
