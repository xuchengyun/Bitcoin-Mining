defmodule PROJECT1.Serverworker do

  def start_link(no_of_worker, caller, no_zero) do
    
     pid = spawn_link(__MODULE__, :mine, [no_of_worker, caller, no_zero])
  end

  def mine(no_of_worker, caller, no_zero) do      
      mineingcoin(1000000000, no_of_worker, no_zero, caller)
  end

  def mineingcoin(no_of_element_perworker, arg, k, caller) when no_of_element_perworker >= 0 do
    # list = 1..no_of_element_perworker
    # Enum.to_list(list)
    core = <<arg + 96::utf8>>
    input_string = "chengyun:server#" <> core <>Integer.to_string(no_of_element_perworker) 
      # IO.puts input_string
      
    output = :crypto.hash(:sha256, input_string) |> Base.encode16(case: :lower)    
    k_zero = String.duplicate("0", k)
    if (String.starts_with? output, k_zero) do
      output = input_string <> ";" <> output
      send caller, {:bitcoin, output}
        # IO.puts input_string <> "core number is " <> Integer.to_string(arg)<> "\n" <> output
    end
    mineingcoin(no_of_element_perworker - 1, arg, k, caller)    
  end

  def mineingcoin(no_of_element_perworker, arg, zeronum, caller) when no_of_element_perworker < 0 do
  end
    

  # def mingingcoin(no_of_element_perworker, arg) when no_of_element_perworker < 0 do
  #   IO.puts "finish"
  # end


  def sha256(string) do
    :crypto.hash(:sha256, string) |> Base.encode16(case: :lower)
  end
end
