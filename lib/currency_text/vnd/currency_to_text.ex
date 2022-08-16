defmodule CurrencyText.CurrencyToText do
  require Logger
  def convert_to_words(value, currency) do
    currency
    |> case do
      "VND" ->
        convert_to_words_vietnamese(value)
      _ ->
        true
        #convert_to_words_en(value)
    end
  end

  defp convert_to_words_vietnamese(value) do
    billions = value |> div(1_000_000_000)
    millions = value |> div(1_000_000) |> rem(1000)
    thousands = value |> div(1_000) |> rem(1000)
    unit = value |> rem(1000)

    %{billions: billions, millions: millions, thousands: thousands, unit: unit}
    |> Logger.error()

    %{billions: billions, millions: millions, thousands: thousands, unit: unit}
    |> CurrencyText.Vnd.Helper.ThreeDigits.build()
    |> String.capitalize()
  end

  defp convert_to_words_en(value) do
    value |> Cldr.Number.to_string(format: :spellout)
  end
end
