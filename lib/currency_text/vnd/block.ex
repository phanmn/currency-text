defmodule CurrencyText.Vnd.Block do
  use TypedStruct

  typedstruct do
    field :type, String.t(), enforce: true
    field :value, integer(), enforce: true
  end
end
