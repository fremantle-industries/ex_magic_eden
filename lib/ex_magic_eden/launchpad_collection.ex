defmodule ExMagicEden.LaunchpadCollection do
  @type t :: %__MODULE__{}

  defstruct ~w[
    symbol
    name
    description
    featured
    edition
    image
    price
    size
    launch_datetime
  ]a
end
