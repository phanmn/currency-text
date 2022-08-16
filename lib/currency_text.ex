defmodule CurrencyText do
  def to_string(%{amount: amount, currency: "VND"}) do
    amount
    |> CurrencyText.Vnd.to_string()
  end
end
