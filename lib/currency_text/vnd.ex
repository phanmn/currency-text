defmodule CurrencyText.Vnd do

  @doc """
    iex> 900000 |> CurrencyText.Vnd.to_string()
    "Chín trăm nghìn đồng"

    iex> 91024012 |> CurrencyText.Vnd.to_string()
    "Chín mươi mốt triệu hai mươi bốn nghìn mười hai đồng"

    iex> 110000 |> CurrencyText.Vnd.to_string()
    "Một trăm mười nghìn đồng"

    iex> 0 |> CurrencyText.Vnd.to_string()
    "Không đồng"

    iex> 1 |> CurrencyText.Vnd.to_string()
    "Một đồng"

    iex> 129481294121 |> CurrencyText.Vnd.to_string()
    "Một trăm hai mươi chín tỷ bốn trăm tám mươi mốt triệu hai trăm chín mươi bốn nghìn một trăm hai mươi mốt đồng"

    iex> 35 |> CurrencyText.Vnd.to_string()
    "Ba mươi lăm đồng"

    iex> 105 |> CurrencyText.Vnd.to_string()
    "Một trăm lẻ năm đồng"

    iex> 105400000 |> CurrencyText.Vnd.to_string()
    "Một trăm lẻ năm triệu bốn trăm nghìn đồng"
  """

  def to_string(amount) when is_float(amount) do
    amount
    |> trunc()
    |> __MODULE__.to_string()
  end

  def to_string(0) do
    "Không đồng"
  end

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
