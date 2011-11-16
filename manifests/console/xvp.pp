class nova::console::xvp(
  $console_xvp_conf_template='/etc/nova/xvp.conf.template'
  ) inherits nova::console {

  nova_config {
    'console_xvp_conf_template': value => $console_xvp_conf_template;
  }

  package { ['libxenserver', 'xvp']:
    ensure   => installed,
    before   => Package["nova-console"]
  }
  file { $console_xvp_conf_template:
    ensure   => present,
    owner    => 'nova',
    require  => Package['nova-console'],
    source   => 'puppet:///modules/nova/xvp.conf.template'
  }
}
