class nova::compute::xenserver(
  $console_host,
  $xenapi_connection_url,
  $xenapi_connection_username,
  $xenapi_connection_password,
  $xenapi_inject_image=false,
  $notification_driver
) {

  nova_config {
    'host': value => $hostname;
    'console_host': value => $console_host;
    'connection_type': value => 'xenapi';
    'xenapi_connection_url': value => $xenapi_connection_url;
    'xenapi_connection_username': value => $xenapi_connection_username;
    'xenapi_connection_password': value => $xenapi_connection_password;
    'xenapi_inject_image': value => $xenapi_inject_image;
    'running_deleted_instance_timeout': value => '0';
    'running_deleted_instance_poll_interval': value => '30';
    'running_deleted_instance_action': value => 'reap';
    'xenapi_vhd_coalesce_max_attempts': value => '720';
    'noflat_injected': value => 'false';
    'instance_name_template': value => 'instance-%(uuid)s';
    'notification_driver': value => $notification_driver;
    'xenapi_generate_swap': value => 'true';
    'firewall_driver': value => 'nova.virt.xenapi.firewall.Dom0IptablesFirewallDriver';
    'glance_num_retries': value => '5';
  }

  package { 'XenAPI':
    ensure   => installed,
    provider => pip
  }
}
