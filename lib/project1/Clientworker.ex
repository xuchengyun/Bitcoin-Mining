defmodule PROJECT1.Clientworker do

  def start_link(no_of_worker, caller) do
     pid = spawn_link(__MODULE__, :beginmine, [no_of_worker, caller])
    #  IO.inspect pid
  end

  def beginmine(no_of_worker, caller) do
      pid = get_serverpid()   
      send pid, {:request, self}     
      zeronum = getzeronum
      mineingcoin(1000000000, no_of_worker, zeronum, caller, pid)
  end

  def getzeronum do
    receive do
			{:zeronum, zeronum} -> zeronum
			_ -> {:error}
		end
  end

  def mineingcoin(no_of_element_perworker, arg, k, caller, pid) when no_of_element_perworker > 0 do
    # list = 1..no_of_element_perworker
    # Enum.to_list(list)
    core = <<arg + 96::utf8>>      
    input_string = "chengyun:client1#" <> core <>Integer.to_string(no_of_element_perworker)       
    output = :crypto.hash(:sha256, input_string) |> Base.encode16(case: :lower)    
    k_zero = String.duplicate("0", k)
    Integer.to_string(k)
    if (String.starts_with? output, k_zero) do
      output = input_string <> ";" <> output
      send caller, {:bitcoin, output}
      send pid, {:bitcoin, output}     
    end
    mineingcoin(no_of_element_perworker - 1, arg, k, caller, pid)    
  end

  def get_serverpid() do
    # IO.puts 11
    case :global.whereis_name(@servername) do
        :undefined -> get_serverpid()
        _ ->  :global.whereis_name(@servername)
    end
    # IO.puts 22
    
   
  end
end
