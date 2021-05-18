defmodule Sugarcane.Utils do
  def remove_first_char(str) when is_binary(str) do
    {_first_char, rest} = String.split_at(str, 1)
    rest
  end
end
