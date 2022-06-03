defmodule ExMagicEden.HttpClientTest do
  use ExUnit.Case, async: false
  import Mock
  doctest ExMagicEden.HTTPClient

  setup_all do
    HTTPoison.start()
    :ok
  end

  test "returns an error tuple for a HTTP timeout" do
    with_mock HTTPoison, request: fn _url -> {:error, %HTTPoison.Error{reason: :timeout}} end do
      assert ExMagicEden.HTTPClient.non_auth_get("/v2/collections", %{}) == {:error, :timeout}
    end
  end

  test "returns an error tuple for a domain lookup failure" do
    with_mock HTTPoison, request: fn _url -> {:error, %HTTPoison.Error{reason: "nxdomain"}} end do
      assert ExMagicEden.HTTPClient.non_auth_get("/v2/collections", %{}) == {:error, :nxdomain}
    end
  end
end
