# == Class: jmeter::server
#
# This class configures the server component of JMeter.
#
# === Examples
#
#   class { 'jmeter::server': }
#
class jmeter::server(
  $server_ip = $jmeter::params::server_ip,
  $plugins_version = $jmeter::params::plugins_version,
  $version = $jmeter::params::version,
) inherits jmeter::params {

  class { 'jmeter':
    jmeter_version         => $version,
    jmeter_plugins_install => True,
    jmeter_plugins_version => $plugins_version,
  }

  $init_template = $osfamily ? {
    debian => 'jmeter/jmeter-init.erb',
    redhat => 'jmeter/jmeter-init.redhat.erb'
  }

  file { '/etc/init.d/jmeter':
    content => template($init_template),
    owner   => root,
    group   => root,
    mode    => 0755,
  }

  if $osfamily == 'debian' {
    exec { 'jmeter-update-rc':
      command     => '/usr/sbin/update-rc.d jmeter defaults',
      subscribe   => File['/etc/init.d/jmeter'],
      refreshonly => true,
    }
  }

  service { 'jmeter':
    ensure    => running,
    enable    => true,
    require   => File['/etc/init.d/jmeter'],
    subscribe => [File['/etc/init.d/jmeter'], Exec['install-jmeter-plugins']],
  }
}
