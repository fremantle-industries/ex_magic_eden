defmodule ExMagicEden.CollectionActivity do
  @type t :: %__MODULE__{}

  defstruct ~w[
    signature
    type
    source
    token_mint
    collection
    slot
    block_time
    buyer
    buyer_referral
    seller
    seller_referral
    price
  ]a
end
