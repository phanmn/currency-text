defmodule CurrencyText.Vnd.Digit do
  use TypedStruct

  typedstruct do
    field(:value, integer(), enforce: true)
    field(:location, integer(), enforce: true)
    field(:block_length, integer(), enforce: true)
    field(:previous_digit, String.t())
  end
@doc ~S"""
      iex> %CurrencyText.Vnd.Block{type: "millions", value: 911} |> CurrencyText.Vnd.Digit.from_block()
      [%CurrencyText.Vnd.Digit{value: "9", location: 0, block_length: 3, previous_digit: nil},
      %CurrencyText.Vnd.Digit{value: "1", location: 1, block_length: 3, previous_digit: %CurrencyText.Vnd.Digit{value: "9", location: 0, block_length: 3, previous_digit: nil}},
      %CurrencyText.Vnd.Digit{value: "1", location: 2, block_length: 3, previous_digit: %CurrencyText.Vnd.Digit{value: "1", location: 1, block_length: 3, previous_digit: %CurrencyText.Vnd.Digit{value: "9", location: 0, block_length: 3, previous_digit: nil}}}]

      iex> %CurrencyText.Vnd.Block{type: "millions", value: 304} |> CurrencyText.Vnd.Digit.from_block()
      [%CurrencyText.Vnd.Digit{value: "3", location: 0, block_length: 3, previous_digit: nil},
      %CurrencyText.Vnd.Digit{value: "0", location: 1, block_length: 3, previous_digit: %CurrencyText.Vnd.Digit{value: "3", location: 0, block_length: 3, previous_digit: nil}},
      %CurrencyText.Vnd.Digit{value: "4", location: 2, block_length: 3, previous_digit: %CurrencyText.Vnd.Digit{value: "0", location: 1, block_length: 3, previous_digit: %CurrencyText.Vnd.Digit{value: "3", location: 0, block_length: 3, previous_digit: nil}}}]

      iex> %CurrencyText.Vnd.Block{type: "millions", value: 8} |> CurrencyText.Vnd.Digit.from_block()
      [%CurrencyText.Vnd.Digit{value: "0", location: 0, block_length: 1, previous_digit: nil},
      %CurrencyText.Vnd.Digit{value: "0", location: 1, block_length: 1, previous_digit: %CurrencyText.Vnd.Digit{value: "0", location: 0, block_length: 1, previous_digit: nil}},
      %CurrencyText.Vnd.Digit{value: "8", location: 2, block_length: 1, previous_digit: %CurrencyText.Vnd.Digit{value: "0", location: 1, block_length: 1, previous_digit: %CurrencyText.Vnd.Digit{value: "0", location: 0, block_length: 1, previous_digit: nil}}}]

      """
  def from_block(block = %CurrencyText.Vnd.Block{}) do
    block_length = block |> CurrencyText.Vnd.Block.length()

    block.value
    |> Integer.to_string()
    |> String.pad_leading(3, "0")
    |> String.split("")
    |> Enum.filter(fn i -> i != "" end)
    |> Enum.reduce([], fn digit, acc ->
      [
        %CurrencyText.Vnd.Digit{
          value: digit,
          location: acc |> length(),
          block_length: block_length,
          previous_digit: acc |> List.first()
        }
        | acc
      ]
    end)
    |> Enum.reverse()
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
        iex> %CurrencyText.Vnd.Digit{value: "0", location: 1, block_length: 3, previous_digit: "2"} |> CurrencyText.Vnd.Digit.to_string()
        "lẻ"

        iex> %CurrencyText.Vnd.Digit{value: "0", location: 1, block_length: 1, previous_digit: "2"} |> CurrencyText.Vnd.Digit.to_string()
        ""

        iex> %CurrencyText.Vnd.Digit{value: "1", location: 1, block_length: 3, previous_digit: "2"} |> CurrencyText.Vnd.Digit.to_string()
        "mười"

        iex> %CurrencyText.Vnd.Digit{value: "8", location: 0, block_length: 2, previous_digit: "2"} |> CurrencyText.Vnd.Digit.to_string()
        "tám trăm"

        iex> %CurrencyText.Vnd.Digit{value: "5", location: 1, block_length: 2, previous_digit: ""} |> CurrencyText.Vnd.Digit.to_string()
        "năm mươi"

        iex> %CurrencyText.Vnd.Digit{value: "4", location: 2, block_length: 3, previous_digit: "2"} |> CurrencyText.Vnd.Digit.to_string()
        "bốn"

        iex> %CurrencyText.Vnd.Digit{value: "1", location: 2, block_length: 3, previous_digit: %CurrencyText.Vnd.Digit{value: "3", location: 1, block_length: 3, previous_digit: "1"}} |> CurrencyText.Vnd.Digit.to_string()
        "mốt"

        iex> %CurrencyText.Vnd.Digit{value: "1", location: 2, block_length: 3, previous_digit: %CurrencyText.Vnd.Digit{value: "1", location: 1, block_length: 3, previous_digit: "1"}} |> CurrencyText.Vnd.Digit.to_string()
        "một"

        iex> %CurrencyText.Vnd.Digit{value: "0", location: 2, block_length: 3, previous_digit: "4"} |> CurrencyText.Vnd.Digit.to_string()
        ""

        iex> %CurrencyText.Vnd.Digit{value: "0", location: 0, block_length: 3, previous_digit: ""} |> CurrencyText.Vnd.Digit.to_string()
        ""
  """
  def to_string(%CurrencyText.Vnd.Digit{
        value: "0",
        location: 1,
        block_length: 3,
        previous_digit: _
      }) do
    "lẻ"
  end

  def to_string(%CurrencyText.Vnd.Digit{
        value: "0",
        location: _,
        block_length: _,
        previous_digit: _
      }) do
    ""
  end

  def to_string(%CurrencyText.Vnd.Digit{
        value: "1",
        location: 1,
        block_length: _,
        previous_digit: _
      }) do
    "mười"
  end

  def to_string(%CurrencyText.Vnd.Digit{
        value: "1",
        location: 2,
        block_length: block_length,
        previous_digit: previous_digit
      })
      when block_length != 1 and previous_digit.value != "1" do
    "mốt"
  end

  def to_string(%CurrencyText.Vnd.Digit{
        value: value,
        location: 0,
        block_length: _,
        previous_digit: _
      }) do
    @digit_map |> Map.get(value) |> Kernel.<>(" trăm")
  end

  def to_string(%CurrencyText.Vnd.Digit{
        value: value,
        location: 1,
        block_length: _,
        previous_digit: _
      }) do
    @digit_map |> Map.get(value) |> Kernel.<>(" mươi")
  end

  def to_string(%CurrencyText.Vnd.Digit{
        value: value,
        location: 2,
        block_length: _,
        previous_digit: _
      }) do
    @digit_map |> Map.get(value)
  end
end
