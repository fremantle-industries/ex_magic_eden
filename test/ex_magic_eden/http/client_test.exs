defmodule ExMagicEden.Http.ClientTest do
  use ExUnit.Case, async: false
  use WithEnv
  alias ExMagicEden.Http
  doctest ExMagicEden.Http.Client

  defmodule TestAdapter do
    def send(request) do
      case request.path do
        "/response_ok" -> {:ok, %Http.Response{status_code: 200, body: "{\"hello\":\"world\"}"}}
        "/response_error" -> {:ok, %Http.Response{status_code: 400, body: "[\"bad request\"]"}}
        "/response_decode_error" -> {:ok, %Http.Response{status_code: 400, body: "not_json"}}
        "/adapter_error" -> {:error, :from_adapter}
      end
    end
  end

  setup_all do
    HTTPoison.start()
    :ok
  end

  test ".send_rest/1 decodes the JSON success response body with a status between 200 and 299" do
    with_env put: [ex_magic_eden: [adapter: TestAdapter]] do
      request = Http.Request.for_path("/response_ok")
      assert {:ok, data} = Http.Client.send_rest(request)
      assert data == %{"hello" => "world"}
    end
  end

  test ".send_rest/1 decodes the JSON error response body with a status between 400 and 499" do
    with_env put: [ex_magic_eden: [adapter: TestAdapter]] do
      request = Http.Request.for_path("/response_error")
      assert {:error, reasons} = Http.Client.send_rest(request)
      assert reasons == ["bad request"]
    end
  end

  test ".send_rest/1 returns an error JSON error response can't be decoded with a status between 400 and 499" do
    with_env put: [ex_magic_eden: [adapter: TestAdapter]] do
      request = Http.Request.for_path("/response_decode_error")
      assert {:error, reason} = Http.Client.send_rest(request)
      assert %Jason.DecodeError{} = reason
      assert reason.data == "not_json"
    end
  end

  test ".send_rest/1 bubbles adapter errors" do
    with_env put: [ex_magic_eden: [adapter: TestAdapter]] do
      request = Http.Request.for_path("/adapter_error")
      assert Http.Client.send_rest(request) == {:error, :from_adapter}
    end
  end
end
