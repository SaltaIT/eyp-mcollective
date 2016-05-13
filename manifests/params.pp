class mcollective::params {

  $connector_default='activemq'
  $default_psk='viscalaterralliure'

  $stomp_port_default='6163'

  case $::osfamily
  {
    'redhat':
    {
      $libdir='/usr/libexec/mcollective'

      #mcollective agent

      $mcollectiveagentpackages= [ 'mcollective', 'rubygem-stomp' ]
      $mcollectiveclientpackages = [ 'mcollective-client' ]
      $mcollectiveagentservice='mcollective'
      $puppetlabspackageprovider='rpm'

      #activemq
      $activemqpackages = [ 'activemq' ]
      $activemq_conf='/etc/activemq/activemq.xml'
      $activemq_conf_template='activemqconf_rh.erb'

      $activemq_ln=undef
      $activemq_lndest=undef
      $activemq_baseconf='/etc/activemq'

      $activemq_sysconf=undef
      $activemq_sysconf_template=undef

      $activemq_jetty="${activemq_baseconf}/jetty.xml"
      $activemq_jetty_template='activemq_jetty.erb'

      $activemq_jetty_realm="${activemq_baseconf}/jetty-realm.properties"
      $activemq_jetty_realm_template='activemq_jetty_realm.erb'

      $activemq_credentials="${activemq_baseconf}/credentials.properties"
      $activemq_credentials_template='activemq_credentials.erb'

      $activemq_servicefile=$activemq_conf

      case $::operatingsystemrelease
      {
        /^5.*$/:
        {
          $puppetlabspackage='http://yum.puppetlabs.com/puppetlabs-release-el-5.noarch.rpm'
        }
        /^6.*$/:
        {
          $puppetlabspackage='http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm'
        }
        /^7.*$/:
        {
          $puppetlabspackage='http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm'
        }
        default: { fail("Unsupported RHEL/CentOS version! - ${::operatingsystemrelease}")  }
      }

    }
    'Debian':
    {
      case $::operatingsystem
      {
        'Ubuntu':
        {
          case $::operatingsystemrelease
          {
            /^14.*$/:
            {
              $libdir='/usr/share/mcollective/plugins'

              #mcollecitve agent

              $mcollectiveagentpackages= [ 'mcollective', 'ruby-stomp' ]
              $mcollectiveclientpackages= [ 'mcollective-client' ]
              $mcollectiveagentservice='mcollective'
              $puppetlabspackage='http://apt.puppetlabs.com/puppetlabs-release-trusty.deb'
              $puppetlabspackageprovider='dpkg'

              #activemq
              $activemqpackages = [ 'activemq' ]
              $activemq_conf='/etc/activemq/instances-available/main/activemq.xml'
              $activemq_conf_template='activemqconf_ubuntu14.erb'

              $activemq_ln='/etc/activemq/instances-enabled/main'
              $activemq_lndest='/etc/activemq/instances-available/main'
              $activemq_baseconf=$activemq_lndest

              $activemq_sysconf='/etc/default/activemq'
              $activemq_sysconf_template='sysconf_debian.erb'

              $activemq_jetty="${activemq_baseconf}/jetty.xml"
              $activemq_jetty_template='activemq_jetty.erb'

              $activemq_jetty_realm="${activemq_baseconf}/jetty-realm.properties"
              $activemq_jetty_realm_template='activemq_jetty_realm.erb'

              $activemq_credentials="${activemq_baseconf}/credentials.properties"
              $activemq_credentials_template='activemq_credentials.erb'

              $activemq_servicefile=$activemq_ln
            }
            default: { fail("Unsupported Ubuntu version! - ${::operatingsystemrelease}")  }
          }
        }
        'Debian': { fail('Unsupported')  }
        default: { fail('Unsupported Debian flavour!')  }
      }
    }
    default: { fail('Unsupported OS!')  }
  }
}
