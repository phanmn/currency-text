defmodule CurrencyText.Vnd.Helper.ToWords do
  def read_block_three(value) do
    value
    |> case do
      0 ->
        ""

      _ ->
        length =
          value
          |> Integer.to_string()
          |> String.length()

        value =
          value
          |> Integer.to_string()
          |> String.pad_leading(3, "0")

        cond do
          value |> String.at(1) == "0" and value |> String.at(2) == "0" ->
            (value |> String.at(0) |> digit_map_value()) <> " trăm"

          value |> String.at(0) == "0" and value |> String.at(1) == "0" ->
            value |> String.at(2) |> digit_map_value()

          true ->
            for i <- 0..2 do
              read_one_digit(%{value: value |> String.at(i), position: i, length: length})
            end
            |> Enum.join(" ")
        end
    end
  end

  defp read_one_digit(%{value: "0", position: 1, length: 3}) do
    "lẻ"
  end

  defp read_one_digit(%{value: "0", position: position, length: _}) when position != 0 do
    ""
  end

  defp read_one_digit(%{value: "1", position: 1, length: _}) do
    "mười"
  end

  defp read_one_digit(%{value: value, position: 0, length: _}) do
    (value |> digit_map_value()) <> " trăm"
  end

  defp read_one_digit(%{value: value, position: 1, length: _}) do
    (value |> digit_map_value()) <> " mươi"
  end

  defp read_one_digit(%{value: value, position: 2, length: _}) do
    value |> digit_map_value()
  end

  defp digit_map_value(value) do
    digit_map = %{
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

    digit_map |> Map.get(value)
  end
end
