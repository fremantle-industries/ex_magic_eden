defmodule ExMagicEden.Token do
  @type t :: %__MODULE__{}

  defstruct ~w[
    mint_address
    owner
    supply
    collection
    name
    update_authority
    primary_sale_happened
    seller_fee_basis_points
    image
    animation_url
    external_url
    attributes
    properties
  ]a
end
