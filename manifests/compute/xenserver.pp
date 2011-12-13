class nova::compute::xenserver(
  $console_host,
  $xenapi_connection_url,
  $xenapi_connection_username,
  $xenapi_connection_password,
  $xenapi_inject_image=false
) {

  nova_config {
    'console_host': value => $console_host;
    'connection_type': value => 'xenapi';
    'xenapi_connection_url': value => $xenapi_connection_url;
    'xenapi_connection_username': value => $xenapi_connection_username;
    'xenapi_connection_password': value => $xenapi_connection_password;
    'xenapi_inject_image': value => $xenapi_inject_image;
  }

  package { 'xenapi':
    ensure   => installed,
    provider => pip
  }
}
