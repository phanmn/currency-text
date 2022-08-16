defmodule CurrencyText.CurrencyToText do
  require Logger
  def convert_to_words(value) do
    value
    |> convert_to_words_vietnamese()
  end

  defp convert_to_words_vietnamese(value) do
    billions = value |> div(1_000_000_000)
    millions = value |> div(1_000_000) |> rem(1000)
    thousands = value |> div(1_000) |> rem(1000)
    unit = value |> rem(1000)

    [%CurrencyText.Vnd.Block{value: billions, type: "billions"},
    %CurrencyText.Vnd.Block{value: millions, type: "millions"},
    %CurrencyText.Vnd.Block{value: thousands, type: "thousands"},
    %CurrencyText.Vnd.Block{value: unit, type: "unit"}]
    |> Enum.map(fn block ->
      block |> CurrencyText.Vnd.Block.to_string()
    end)
    |> Enum.filter(fn i -> i != "" end)
    |> Enum.join(" ")
    |> Kernel.<>(" đồng")
    |> String.capitalize()

  end
end
