class nova::api(
  $enabled=false,
  $image_service = 'nova.image.local.LocalImageService',
  $glance_api_servers = 'localhost:9292',
  $glance_host = 'localhost',
  $glance_port = '9292'
) {

  Exec['post-nova_config'] ~> Service['nova-api']
  Exec['nova-db-sync'] ~> Service['nova-api']

  if $image_service == 'nova.image.glance.GlanceImageService' {
    nova_config {
      'glance_api_servers': value => $glance_api_servers;
      'glance_host': value => $glance_host;
      'glance_port': value => $glance_port;
    }
  }

  if $enabled {
    $service_ensure = 'running'
  } else {
    $service_ensure = 'stopped'
  }

  exec { "initial-db-sync":
    command     => "/usr/bin/nova-manage db sync",
    refreshonly => true,
    require     => [Package["nova-common"], Nova_config['sql_connection']],
  }

  package { "nova-api":
    ensure  => present,
    require => Package["python-greenlet"],
    notify  => Exec['initial-db-sync'],
  }
  service { "nova-api":
    ensure  => $service_ensure,
    enable  => $enabled,
    require => Package["nova-api"],
    #subscribe => File["/etc/nova/nova.conf"]
  }
}
