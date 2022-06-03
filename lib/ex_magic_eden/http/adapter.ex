defmodule ExMagicEden.Http.Adapter do
  alias ExMagicEden.Http

  @type error_reason :: :timeout | :nxdomain | Maptu.Extension.non_strict_error_reason() | term
  @type result :: {:ok, Http.Response.t()} | {:error, error_reason}

  @callback send(Http.Request.t()) :: result
end
