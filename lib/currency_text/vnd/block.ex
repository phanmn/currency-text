defmodule CurrencyText.Vnd.Block do
  use TypedStruct

  typedstruct do
    field :type, String.t(), enforce: true
    field :value, integer(), enforce: true
  end

  def to_string(block = %__MODULE__{}) do
    block
    |> CurrencyText.Vnd.Digit.from_block()
    |> Enum.map(fn digit ->
      digit |> CurrencyText.Vnd.Digit.to_string()
    end)
    |> Enum.join(" ")
    |> Kernel.<>(
      block.type
      |> case do
        "billions" -> " tỷ"
        "millions" -> " triệu"
        "thoudsands" -> " nghìn"
        _ -> ""
      end
    )
  end

  def length(block = %CurrencyText.Vnd.Block{}) do
    block.value |> Integer.to_string() |> String.length()
  end
end
