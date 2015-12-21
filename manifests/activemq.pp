class mcollective::activemq	(
					$adminpw,
					$username='mcollective',
					$userpw,
					$stomp_port=$mcollective::params::stomp_port_default,
				) inherits params {

	package { $mcollective::params::activemqpackages:
		ensure => 'installed',
	}

	file { $mcollective::params::activemq_conf:
		ensure  => 'present',
		owner   => 'root',
		group   => 'root',
		mode    => '0644',
		content => template("${module_name}/${mcollective::params::activemq_conf_template}"),
		require => Package[$mcollective::params::activemqpackages],
		notify  => Service['activemq'],
	}

	if($mcollective::params::activemq_ln)
	{
		file { $mcollective::params::activemq_ln:
			ensure  => $mcollective::params::activemq_lndest,
			require => File[$mcollective::params::activemq_conf],
			notify  => Service['activemq'],
		}
	}

	if($mcollective::params::activemq_sysconf)
	{
		file { $mcollective::params::activemq_sysconf:
			ensure  => 'present',
			owner   => 'root',
			group   => 'root',
			mode    => '0644',
			content => template("${module_name}/${mcollective::params::activemq_sysconf_template}"),
			require => File[$mcollective::params::activemq_conf],
			notify  => Service['activemq'],
		}
	}

	#TODO: falta algo per ubuntu, segurament datadir
	service { 'activemq':
		ensure  => 'running',
		enable  => true,
		require => File[ [ $mcollective::params::activemq_servicefile,
										 ] ],
	}

}
