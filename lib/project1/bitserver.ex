defmodule PROJECT1.Bitserver do

  def parse_args(args) do
    {:ok, serverip} = :inet.getif()
    IO.inspect serverip
		serverip = Enum.at(serverip, 0)
    ip = Kernel.elem(serverip, 0)
    IO.inspect ip
    
    ip = :inet_parse.ntoa(ip)
    IO.inspect ip
    
		server_name = "server@#{ip}"
    Node.start(String.to_atom(server_name))
    Node.set_cookie(Node.self(), :project1)
    
    no_zero = String.to_integer(args)
    pid = self
		:global.register_name(@servername, pid)
    noOfWorkers = :erlang.system_info(:schedulers_online)
    IO.puts "the number of core is " <> Integer.to_string(noOfWorkers)
    findcoin(noOfWorkers, no_zero)
    connectloop(no_zero)
  end

  def connectloop(no_zero) do
    receive do
      {:request, pid} ->
	msg = {:zeronum, no_zero}
	send pid, msg
	connectloop(no_zero)
      {:bitcoin, msg} ->
	IO.puts msg
	connectloop(no_zero)
    end
  end

  def findcoin(no_of_workers, no_zero) do
    caller = self
    IO.puts no_of_workers
    numbers = 1..no_of_workers
    Enum.to_list(numbers)
    pid = Enum.map(numbers, fn(n) -> PROJECT1.Serverworker.start_link(n, caller, no_zero) end) 
  end

  def handleclient(zero) do
    portnumber = 10002
    caller = self
    zero = Enum.at(zero, 0) 
    zero = String.to_integer(zero)
    Tcp.start(zero, portnumber)
  end

end





