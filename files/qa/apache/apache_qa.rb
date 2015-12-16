module MCollective
  module Agent
    class ApacheQA<RPC::Agent
      action "run" do
	       result = run(request["netstat -tpln | grep 80"], :stdout => :out, :stderr => :err)

         if result[:stdout]==0
           reply[:msg] = result
         else
          reply.fail(result)

      end
    end
  end
end
