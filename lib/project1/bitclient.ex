defmodule PROJECT1.Bitclient do    
    
  def parse_args(args) do
    serverip = args

    IO.puts serverip
    noOfWorkers = :erlang.system_info(:schedulers_online)
    IO.puts "the number of core is " <> Integer.to_string(noOfWorkers)
    server_name = "server@#{serverip}"
    {:ok, clientip} = :inet.getif()
    clientip = Enum.at(clientip, 0)
    
    clientip = Kernel.elem(clientip, 0)
    clientip = :inet_parse.ntoa(clientip)
    client_name = "client@#{clientip}"
    IO.puts client_name
    Node.start(String.to_atom(client_name))
    Node.set_cookie(Node.self(), :project1)
    Node.connect(String.to_atom(server_name))
    findcoin(noOfWorkers)
    receivemessage(noOfWorkers, serverip,[])    
  end

#   def initialize(no_of_workers, serverip) do      
#       receivemessage(no_of_workers, serverip, [])
#   end

  def findcoin(no_of_workers) do
    IO.puts no_of_workers
    numbers = 1..no_of_workers
    for n <- numbers do
        fn(n) -> PROJECT1.Clientworker.start_link(n, self) end
    end
    Enum.to_list(numbers)
    caller = self      
    pid = Enum.map(numbers, fn(n) -> PROJECT1.Clientworker.start_link(n, caller) end) 
  end


  def receivemessage(no_of_workers, serverip, list) do
    receive do
      {:bitcoin, coin} -> 
        list = [coin| list]
        receivemessage(no_of_workers, serverip, list)
      {:nozero, data, socket} -> 
        data = String.to_integer(data)
        receivemessage(no_of_workers, serverip, list)
      {:stop} ->
        IO.puts list
        self.exit()
    after 10000 ->
      send self,{:stop}
    end

  end

  def get_serverpid() do
    case serverpid = :global.whereis_name(@servername) do
        :undefined -> get_serverpid()
    end
    serverpid
  end
end
