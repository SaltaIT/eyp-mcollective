require 'spec_helper_acceptance'

describe 'mcollective class' do

  context 'basic setup' do
    # Using puppet_apply as a helper
    it 'should work with no errors based on the example' do
      pp = <<-EOF

      class { 'mcollective':
    		password => 'aaa',
    		hostname => 'localhost',
    		agent=>true,
    		client=>true,
    	}

      class { 'mcollective::activemq':
    		adminpw => 'admin',
    		userpw => 'aaa',
    	}
      EOF

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    it 'yui --version should give us the default version (2.4.8)' do
       shell("/usr/local/bin/yui --version") do |r|
         expect(r.stderr).to match(/2\.4\.8/)
       end
     end

  end
end
