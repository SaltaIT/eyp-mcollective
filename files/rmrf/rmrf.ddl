metadata :name        => 'rmrf',
         :description => 'rmrf service for MCollective',
         :author      => 'Jordi Prats',
         :license     => 'GPLv2',
         :version     => '1.0',
         :url         => 'http://systemadmin.es',
         :timeout     => 60

action 'run', :description => 'executes commands it receives' do
    display :always

    input :cmd,
          :prompt      => 'command',
          :description => '$ ',
          :type        => :string,
          :validation  => '.*',
          :optional    => false,
          :maxlength   => 1024

    output :msg,
        :description => 'command output',
        :display_as  => 'output',
        :default     => ''
end
