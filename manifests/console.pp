# this class should probably never be declared except
# from the virtualization implementation of the console node
class nova::console(
  #$api_server,
  $enabled = false,
  $api_port = 8773,
  $aws_address = '169.254.169.254'
) {

  Exec['post-nova_config'] ~> Service['nova-console']
  Exec['nova-db-sync']  ~> Service['nova-console']

  if $enabled {
    $service_ensure = 'running'
  } else {
    $service_ensure = 'stopped'
  }

  package { "nova-console":
    ensure => present,
    require => Package['nova-common'],
  }

  service { "nova-console":
    ensure  => $service_ensure,
    enable  => $enabled,
    require => Package["nova-console"],
  }

}
