defmodule ExMagicEden.CollectionStats.ShowTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  import Mock
  doctest ExMagicEden.CollectionStats.Show

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
    with_mock HTTPoison, request: fn _url -> {:error, %HTTPoison.Error{reason: :timeout}} end do
      assert ExMagicEden.CollectionStats.Show.get("bday") == {:error, :timeout}
    end
  end
end
