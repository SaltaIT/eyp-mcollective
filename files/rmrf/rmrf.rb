module MCollective
  module Agent
    class Rmrf<RPC::Agent
      action "run" do
	       reply[:msg] = run(request[:cmd], :stdout => :out, :stderr => :err)
      end
    end
  end
end
