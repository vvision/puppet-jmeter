# == Class: jmeter::plugins
#
# This class installs the latest stable version of JMeter plugins.
#
#
class jmeter::plugins(
  $plugins_version = $jmeter::params::plugins_version,
) inherits jmeter::params {

  Exec { path => '/bin:/usr/bin:/usr/sbin' }

  exec { 'download-jmeter-plugins':
    command => "wget -P /root http://jmeter-plugins.googlecode.com/files/JMeterPlugins-${plugins_version}.zip",
    creates => '/root/JMeterPlugins-${plugins_version}.zip'
  }

  exec { 'install-jmeter-plugins':
    command => "unzip -q -o -d JMeterPlugins JMeterPlugins-${plugins_version}.zip && mv JMeterPlugins/JMeterPlugins.jar /usr/share/jmeter/lib/ext",
    cwd     => '/root',
    creates => '/usr/share/jmeter/lib/ext/JMeterPlugins.jar',
    require => [Package['unzip'], Exec['install-jmeter'], Exec['download-jmeter-plugins']],
  }
}
