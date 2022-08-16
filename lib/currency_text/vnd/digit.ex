defmodule CurrencyText.Vnd.Digit do
  use TypedStruct

  typedstruct do
    field :value, integer(), enforce: true
    field :location, integer(), enforce: true
    field :block_length, integer(), enforce: true
  end
end
