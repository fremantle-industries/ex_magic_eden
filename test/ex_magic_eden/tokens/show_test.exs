defmodule ExMagicEden.Tokens.ShowTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  use WithEnv
  doctest ExMagicEden.Tokens.Show

  @mint_address "5joGadC3Z5aSm4PsCFRtoAKTEtvLYT2iU8nFaNTcjyMe"

  defmodule TestAdapter do
    def send(_request) do
      {:error, :from_adapter}
    end
  end

  setup_all do
    HTTPoison.start()
    :ok
  end

  test ".get/1" do
    use_cassette "tokens/show/get_ok" do
      assert {:ok, collection_stat} = ExMagicEden.Tokens.Show.get(@mint_address)
      assert %ExMagicEden.Token{} = collection_stat
      assert collection_stat.mint_address != nil
    end
  end

  test ".get/n bubbles error tuples" do
    with_env put: [ex_magic_eden: [adapter: TestAdapter]] do
      assert ExMagicEden.Tokens.Show.get(@mint_address) == {:error, :from_adapter}
    end
  end
end
