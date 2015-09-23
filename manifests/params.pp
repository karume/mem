# Class midonet_mem::params
#
# Specify values for parameters and variables for each supported platform
#
class midonet_mem::params {
  case $::osfamily {
    'RedHat': {
      $mem_package             = 'midonet-manager'
      $manage_distro_repo      = true
      $manage_epel_repo        = true
      $midonet_key             = 'CBCBF7F7F25FECC4D636073CE0DDD6FF725F1F73'
      $midonet_stage           = 'stable'
      $midonet_thirdparty_repo = 'http://repo.midonet.org/misc/RHEL'
    }

    'Debian': {
      $mem_package             = 'midonet-manager'
      $midonet_key             = 'BC4E4E90DDA81C21396081CC67B38D3A054314CD'
      $midonet_stage           = 'trusty'
      $manage_distro_repo      = true
      $midonet_thirdparty_repo = 'http://repo.midonet.org/misc'
    }

    default: {
      fail("Unsupported platform: midonet-${module_name} only supports RedHat and Debian based OS")
    }
  }

  # midonet_mem::manager
  $agent_config_api_host      = "http://${::ipaddress}:8459"
  $agent_config_api_namespace = 'conf'
  $api_host                   = "http://${::ipaddress}:8080"
  $api_namespace              = 'midonet-api'
  $api_token                  = '999888777666' # Default mocked value in midonet-api
  $api_version                = '1.9'
  $login_host                 = "http://${::ipaddress}:8080"
  $mem_config_file            = "${mem_install_path}/config/client.js"
  $mem_install_path           = '/var/www/html/midonet-manager'
  $poll_enabled               = true
  $trace_api_host             = "http://${::ipaddress}:8080"
  $traces_ws_url              = "ws://${::ipaddress}:8460"

  # midonet_mem::vhost
  $apache_port = '80'
  $servername  = "http://$::ipaddress"
  $docroot     = '/var/www/html'
}

