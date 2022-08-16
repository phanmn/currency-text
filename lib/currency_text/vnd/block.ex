defmodule CurrencyText.Vnd.Block do
  use TypedStruct

  typedstruct do
    field(:type, String.t(), enforce: true)
    field(:value, integer(), enforce: true)
  end

  @doc ~S"""
        iex> CurrencyText.Vnd.Block.to_string(%CurrencyText.Vnd.Block{type: "billions", value: 102})
        "một trăm lẻ hai tỷ"

        iex> CurrencyText.Vnd.Block.to_string(%CurrencyText.Vnd.Block{type: "millions", value: 212})
        "hai trăm mười hai triệu"

        iex> CurrencyText.Vnd.Block.to_string(%CurrencyText.Vnd.Block{type: "thousands", value: 900})
        "chín trăm nghìn"

        iex> CurrencyText.Vnd.Block.to_string(%CurrencyText.Vnd.Block{type: "unit", value: 30})
        "ba mươi"
  """

  def to_string(block = %__MODULE__{}) do
    block
    |> CurrencyText.Vnd.Digit.from_block()
    |> Enum.map(fn digit ->
      digit |> CurrencyText.Vnd.Digit.to_string()
    end)
    |> Enum.filter(fn i -> i != "" end)
    |> Enum.join(" ")
    |> case do
      "" ->
        ""

      v ->
        v
        |> Kernel.<>(
          block.type
          |> case do
            "billions" -> " tỷ"
            "millions" -> " triệu"
            "thousands" -> " nghìn"
            _ -> ""
          end
        )
    end
  end

  def length(block = %CurrencyText.Vnd.Block{}) do
    block.value |> Integer.to_string() |> String.length()
  end
end
