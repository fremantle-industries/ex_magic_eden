defmodule ExMagicEden.Collection do
  @type t :: %__MODULE__{}

  defstruct ~w[
    symbol
    name
    description
    image
    twitter
    discord
    website
    categories
    is_flagged
    flag_message
  ]a
end
