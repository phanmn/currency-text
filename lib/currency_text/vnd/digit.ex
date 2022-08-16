defmodule CurrencyText.Vnd.Digit do
  use TypedStruct

  typedstruct do
    field(:value, integer(), enforce: true)
    field(:location, integer(), enforce: true)
    field(:block_length, integer(), enforce: true)
  end

  def from_block(block = %CurrencyText.Vnd.Block{}) do
    block_length = block |> CurrencyText.Vnd.Block.length()

    block.value
    |> Integer.to_string()
    |> String.pad_leading(3, "0")
    |> String.split("")
    |> Enum.filter(fn i -> i != "" end)
    |> Enum.with_index()
    |> Enum.map(fn {digit, index} ->
      %CurrencyText.Vnd.Digit{
        value: digit,
        location: index,
        block_length: block_length
      }
    end)
  end

  @digit_map %{
    "0" => "không",
    "1" => "một",
    "2" => "hai",
    "3" => "ba",
    "4" => "bốn",
    "5" => "năm",
    "6" => "sáu",
    "7" => "bảy",
    "8" => "tám",
    "9" => "chín"
  }

  @doc ~S"""
    Convert digit to string
        iex> %CurrencyText.Vnd.Digit{value: "0", location: 1, block_length: 3} |> CurrencyText.Vnd.Digit.to_string()
        "lẻ"

        iex> %CurrencyText.Vnd.Digit{value: "0", location: 1, block_length: 1} |> CurrencyText.Vnd.Digit.to_string()
        ""

        iex> %CurrencyText.Vnd.Digit{value: "1", location: 1, block_length: 3} |> CurrencyText.Vnd.Digit.to_string()
        "mười"

        iex> %CurrencyText.Vnd.Digit{value: "8", location: 0, block_length: 2} |> CurrencyText.Vnd.Digit.to_string()
        "tám trăm"

        iex> %CurrencyText.Vnd.Digit{value: "5", location: 1, block_length: 2} |> CurrencyText.Vnd.Digit.to_string()
        "năm mươi"

        iex> %CurrencyText.Vnd.Digit{value: "4", location: 2, block_length: 3} |> CurrencyText.Vnd.Digit.to_string()
        "bốn"
  """
  def to_string(%CurrencyText.Vnd.Digit{value: "0", location: 1, block_length: 3}) do
    "lẻ"
  end

  def to_string(%CurrencyText.Vnd.Digit{value: "0", location: location, block_length: _}) when location != 0 do
    ""
  end

  def to_string(%CurrencyText.Vnd.Digit{value: "1", location: 1, block_length: _}) do
    "mười"
  end

  def to_string(%CurrencyText.Vnd.Digit{value: value, location: 0, block_length: _}) do
    @digit_map |> Map.get(value) |> Kernel.<>(" trăm")
  end

  def to_string(%CurrencyText.Vnd.Digit{value: value, location: 1, block_length: _}) do
    @digit_map |> Map.get(value) |> Kernel.<>(" mươi")
  end

  def to_string(%CurrencyText.Vnd.Digit{value: value, location: 2, block_length: _}) do
    @digit_map |> Map.get(value)
  end

end
