defmodule ExMagicEden.ListedNFT do
  @type t :: %__MODULE__{}

  defstruct ~w[
    attributes
    collection_name
    collection_title
    creators
    escrow_pubkey
    id
    img
    is_tradeable
    mint_address
    on_chain_collection
    owner
    price
    rarity
    title
    v2
  ]a
end
