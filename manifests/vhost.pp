class midonet_mem::vhost {

  include ::midonet_mem::params
  $proxy_pass = [
    { 'path' => "/$midonet_mem::params::api_namespace",
      'url'  => "$midonet_mem::params::api_host"
    }
  ]

  include apache
  apache::vhost { 'midonet-mem':
    port       => '80',
    docroot    => "$midonet_mem::params::mem_install_path",
    proxy_pass => $proxy_pass
  }

}

