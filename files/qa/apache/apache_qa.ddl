metadata :name        => 'apache_qa',
         :description => 'QA for Apache',
         :author      => 'Jordi Prats',
         :license     => 'GPLv2',
         :version     => '1.0',
         :url         => 'http://systemadmin.es',
         :timeout     => 60

action 'run', :description => 'executes QA tests' do
    display :always

    output :msg,
        :description => 'QA output',
        :display_as  => 'output',
        :default     => ''
end
