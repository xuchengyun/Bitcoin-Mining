defmodule Project1 do
  @moduledoc """
  Documentation for Project1.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Project1.hello
      :world

  """
  def hello do
    :world
  end

  def main(args) do
    args = Enum.at(args, 0)
    if (String.length(args) < 4) do
      PROJECT1.Bitserver.parse_args(args)
    else
      PROJECT1.Bitclient.parse_args(args)      
    end
  end
end
