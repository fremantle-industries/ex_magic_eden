defmodule ExMagicEden.CollectionStats.ShowTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  use WithEnv
  doctest ExMagicEden.CollectionStats.Show

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
    use_cassette "collection_stats/show/get_ok" do
      assert {:ok, collection_stat} = ExMagicEden.CollectionStats.Show.get("bday")
      assert %ExMagicEden.CollectionStat{} = collection_stat
      assert collection_stat.floor_price != nil
    end
  end

  test ".get/n bubbles error tuples" do
    with_env put: [ex_magic_eden: [adapter: TestAdapter]] do
      assert ExMagicEden.CollectionStats.Show.get("bday") == {:error, :from_adapter}
    end
  end
end
