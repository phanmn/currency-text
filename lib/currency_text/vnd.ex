defmodule CurrencyText.Vnd do
  def to_string(amount) do
    billions = amount |> div(1_000_000_000)
    millions = amount |> div(1_000_000) |> rem(1000)
    thousands = amount |> div(1_000) |> rem(1000)
    unit = amount |> rem(1000)

    [
      %CurrencyText.Vnd.Block{value: billions, type: "billions"},
      %CurrencyText.Vnd.Block{value: millions, type: "millions"},
      %CurrencyText.Vnd.Block{value: thousands, type: "thousands"},
      %CurrencyText.Vnd.Block{value: unit, type: "unit"}
    ]
    |> Enum.map(&CurrencyText.Vnd.Block.to_string/1)
    |> Enum.filter(fn i -> i != "" end)
    |> Enum.join(" ")
    |> Kernel.<>(" đồng")
    |> String.capitalize()
  end
end
