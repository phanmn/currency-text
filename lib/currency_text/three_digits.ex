defmodule CurrencyText.ThreeDigits do
  require Logger
  def build(value) do
    ""
    |> build(value)
  end

  defp build(result, %{billions: billions} = value) do
    in_words = billions |> CurrencyText.Helper.Helper.read_block_three()

    in_words
    |> case do
      "" ->
        result
      v ->
        (result <> v <> " tỷ ")
    end
    |> build(value |> Map.drop([:billions]))
  end

  defp build(result, %{millions: millions} = value) do
    in_words = millions |> CurrencyText.Helper.Helper.read_block_three()

    in_words
    |> case do
      "" ->
        result
      v ->
        (result <> v <> " triệu ")
    end
    |> build(value |> Map.drop([:millions]))
  end

  defp build(result, %{thousands: thousands} = value) do
    in_words = thousands |> CurrencyText.Helper.Helper.read_block_three()

    in_words
    |> case do
      "" ->
        result
      v ->
        (result <> v <> " nghìn ")
    end
    |> build(value |> Map.drop([:thousands]))
  end

  defp build(result, %{unit: unit} = value) do
    in_words = unit |> CurrencyText.Helper.Helper.read_block_three()

    in_words
    |> case do
      "" ->
        result
      v ->
        (result <> v <> " đồng")
    end
  end
end
