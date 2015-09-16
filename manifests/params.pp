# Class midonet_mem::params
#
# Specify values for parameters and variables for each supported platform
#
class midonet_mem::params {
  case $::osfamily {
    'RedHat': {
      $mem_package = 'midonet-manager'
      $midonet_key = '50F18FCF'
      $midonet_stage = 'trusty'
      $manage_distro_repo = true
      $manage_epel_repo = true
      $midonet_thirdparty_repo = 'http://repo.midonet.org/misc/RHEL'
    }

    'Debian': {
      $mem_package = 'midonet-manager'
      $midonet_key = 'BC4E4E90DDA81C21396081CC67B38D3A054314CD'
      $midonet_stage = 'trusty'
      $manage_distro_repo = true
      $midonet_thirdparty_repo = 'http://repo.midonet.org/misc'
    }

    default: {
      fail("Unsupported platform: midonet-${module_name} only supports RedHat and Debian based OS")
    }
  }

  # midonet_mem (init)
  $api_namespace = 'midonet-api'
  $agent_config_api_namespace = 'conf'
  $mem_install_path = '/var/www/html/midonet-manager'
  $mem_config_file = "${mem_install_path}/config/client.js"
  $keystone_token = '999888777666' # Default mocked value in midonet-api
  $api_host = "http://${::ipaddress}:8080"
  $login_host = "http://${::ipaddress}:8080"
  $trace_api_host = "http://${::ipaddress}:8080"
  $traces_ws_url = "ws://${::ipaddress}:8460"
  $api_version = '1.9'
  $api_token = $keystone_token # or false
  $agent_config_api_host = "http://${::ipaddress}:8459"
  $poll_enabled = true

  # midonet_mem::vhost
  $apache_port = '80'
  $servername  = "http://$::ipaddress"
  $docroot     = '/var/www/html'
}

