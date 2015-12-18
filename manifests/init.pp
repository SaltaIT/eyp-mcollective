class mcollective	(
				$connector=$mcollective::params::collector_default,
				$username="mcollective",
				$password,
				$hostname,
				$psk=$mcollective::params::default_psk,
				$customfactspattern=undef,
				$customfactsfile='/etc/mcollective/facts.yaml',
				$subcollectives=undef,
				$ensure='installed',
				$agent=true,
				$client=false,
				$plugins_packages = [ 'package', 'service', 'puppet' ],
				$plugins_packages_ensure='present',
				$custom_plugins = [ 'rmrf' ],

			) inherits mcollective::params {

	validate_string($connector)
	validate_string($username)
	validate_string($password)
	validate_string($hostname)
	validate_string($psk)

	validate_re($connector, [ '^activemq$' ], "Not a supported connector: $version")

	validate_re($ensure, [ '^installed$', '^latest$' ], "Not a valid package status: ${package_status}")


	if($subcollectives)
	{
		validate_array($subcollectives)
	}

	Exec {
		path => '/sbin:/bin:/usr/sbin:/usr/bin',
	}

	if ! defined(Package['puppetlabs-release'])
	{
		package { 'puppetlabs-release':
			ensure   => 'installed',
			provider => $mcollective::params::puppetlabspackageprovider,
			source   => $mcollective::params::puppetlabspackage,
			notify   => Exec['update puppetlabs repo'],
		}
	}

	if($mcollective::params::puppetlabspackageprovider=="dpkg")
	{
		exec { 'update puppetlabs repo':
			command     => 'apt-get update',
			require     => Package['puppetlabs-release'],
			refreshonly => true,
		}
	}
	else
	{
		exec { 'update puppetlabs repo':
			command     => 'echo systemadmin.es - best blog ever',
			require     => Package['puppetlabs-release'],
			refreshonly => true,
		}
	}

	package { $mcollectiveagentpackages:
		ensure  => $ensure,
		require => Exec['update puppetlabs repo'],
		notify  => Service[$mcollectiveagentservice],
	}

	if($agent)
	{

		if($plugins_packages)
		{
			$agent_plugin_packages=suffix(prefix($plugins_packages, 'mcollective-'), '-agent')
			$agent_plugin_packages_common=suffix(prefix($plugins_packages, 'mcollective-'), '-common')

			package { $agent_plugin_packages:
				ensure  => $plugins_packages_ensure,
				require => Package[$mcollectiveagentpackages],
				notify  => Service[$mcollectiveagentservice],
			}

			ensure_packages($agent_plugin_packages_common,
				{
					ensure  => $plugins_packages_ensure,
					require => Package[$mcollectiveagentpackages],
					notify  => Service[$mcollectiveagentservice],
				}
			)
		}

		exec { "mkdir -p ${libdir} mcollective agent":
			command => "mkdir -p ${libdir}/mcollective/agent",
			creates => "${libdir}/mcollective/agent",
		}

		#agent rmrf
		if member($custom_plugins, 'rmrf')
		{

			file { "${libdir}/mcollective/agent/rmrf.rb":
				ensure   => 'present',
				owner    => 'root',
				group    => 'root',
				mode     => '0644',
				source 	 => "puppet:///modules/${module_name}/rmrf/rmrf.rb",
				notify   => Service[$mcollectiveagentservice],
				require  => [Exec["mkdir -p ${libdir} mcollective agent"], Package[$mcollectiveagentpackages]],
			}

			if ! defined(File["${libdir}/mcollective/agent/rmrf.ddl"])
			{
				file { "${libdir}/mcollective/agent/rmrf.ddl":
					ensure   => 'present',
					owner    => 'root',
					group    => 'root',
					mode     => '0644',
					source 	 => "puppet:///modules/${module_name}/rmrf/rmrf.ddl",
					notify   => Service[$mcollectiveagentservice],
					require  => [Exec["mkdir -p ${libdir} mcollective agent"], Package[$mcollectiveagentpackages]],
				}
			}

		}

		file { '/etc/mcollective/server.cfg':
			ensure  => 'present',
			owner   => 'root',
			group   => 'root',
			mode    => '0644',
			require => Package[$mcollectiveagentpackages],
			notify  => Service[$mcollectiveagentservice],
			content => template("mcollective/agentconf.erb")
		}

		if($customfactspattern)
		{
			#facter -py | grep
			exec { 'customfacts':
				command => "facter -py | grep '${customfactspattern}' > ${customfactsfile}",
				notify  => Service[$mcollectiveagentservice],
				require => File['/etc/mcollective/server.cfg'],
			}
		}
		else
		{
			#facter -py
			exec { 'customfacts':
				command => "facter -py > ${customfactsfile}",
				notify  => Service[$mcollectiveagentservice],
				require => File['/etc/mcollective/server.cfg'],
			}
		}

		service { $mcollectiveagentservice:
			enable  => true,
			ensure  => "running",
			require => Exec['customfacts'],
		}
	}

	if($client)
	{
		if(! $agent)
		{
			if member($custom_plugins, 'rmrf')
			{
				#sanity check
				if ! defined(File["${libdir}/mcollective/agent/rmrf.ddl"])
				{
					file { "${libdir}/mcollective/agent/rmrf.ddl":
						ensure   => 'present',
						owner    => 'root',
						group    => 'root',
						mode     => '0644',
						source 	 => "puppet:///modules/${module_name}/rmrf/rmrf.ddl",
						require  => Exec["mkdir -p ${libdir} mcollective agent"],
					}
				}
			}
		}

		if($plugins_packages)
		{
			$client_plugin_packages=suffix(prefix($plugins_packages, 'mcollective-'), '-client')
			$client_plugin_packages_common=suffix(prefix($plugins_packages, 'mcollective-'), '-common')

			package { $client_plugin_packages:
				ensure  => $plugins_packages_ensure,
				require => Package[$mcollectiveagentpackages],
			}

			ensure_packages($client_plugin_packages_common,
				{
					ensure  => $plugins_packages_ensure,
					require => Package[$mcollectiveagentpackages],
					notify  => Service[$mcollectiveagentservice],
				}
			)
		}

		file { '/etc/mcollective/client.cfg':
			ensure  => 'present',
			owner   => 'root',
			group   => 'root',
			mode    => '0644',
			require => Package[$mcollectiveagentpackages],
			content => template("${module_name}/clientconf.erb")
		}
	}
}
