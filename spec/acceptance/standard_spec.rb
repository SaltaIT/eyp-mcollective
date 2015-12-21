require 'spec_helper_acceptance'

describe 'mcollective class' do

  context 'basic setup (mcollective client with activemq)' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
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

    it 'mco ping' do
      expect(shell("sleep 60; mco ping -t 5 --dt 5 --connection-timeout 5").exit_code).to be_zero
    end
  end

  context 'different stomp port (mcollective client with activemq)' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOF

      class { 'mcollective':
        password => 'aaa',
        hostname => 'localhost',
        agent=>true,
        client=>true,
        stomp_port=>'8888',
      }

      class { 'mcollective::activemq':
        adminpw => 'admin',
        userpw => 'aaa',
        stomp_port=>'8888',
      }
      EOF

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    it 'mco ping stomp 8888' do
      expect(shell("sleep 60; mco ping -t 5 --dt 5 --connection-timeout 5").exit_code).to be_zero
    end
  end

  context 'mcollective connecting to a closed port' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOF

      class { 'mcollective':
        password => 'aaa',
        hostname => 'localhost',
        agent=>true,
        client=>true,
        stomp_port=>'9999',
      }

      class { 'mcollective::activemq':
        adminpw => 'admin',
        userpw => 'aaa',
        stomp_port=>'8888',
      }
      EOF

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    it 'mco ping should fail to connect to a closed port' do
      expect(shell("sleep 60; mco ping -t 5 --dt 5 --connection-timeout 5")).to raise_error
    end
  end

end
