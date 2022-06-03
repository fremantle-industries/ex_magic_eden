defmodule ExMagicEden.Http.Request do
  @type protocol :: String.t()
  @type domain :: String.t()
  @type path :: String.t()
  @type verb :: :get | :post | :put | :delete
  @type params :: map

  @type t :: %__MODULE__{
    protocol: protocol | nil,
    domain: domain | nil,
    path: path,
    query: String.t() | nil,
    body: String.t() | nil,
    headers: keyword,
    verb: verb | nil
  }

  defstruct ~w[protocol domain path query body headers verb]a

  @spec for_path(path) :: t
  def for_path(path) do
    %__MODULE__{path: path, headers: []}
  end

  @spec with_query(t, params) :: t
  def with_query(request, params) do
    query = URI.encode_query(params, :www_form)
    %{request | query: query}
  end

  @spec with_protocol(t, protocol) :: t
  def with_protocol(request, protocol) do
    %{request | protocol: protocol}
  end

  @spec with_domain(t, domain) :: t
  def with_domain(request, domain) do
    %{request | domain: domain}
  end

  @spec url(t) :: String.t()
  def url(request) do
    %URI{
      scheme: request.protocol,
      host: request.domain,
      path: request.path,
      query: request.query
    }
    |> URI.to_string()
    |> String.trim("?")
  end
end
