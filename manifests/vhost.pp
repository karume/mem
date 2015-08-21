class midonet_mem::vhost {

  include ::midonet_mem::params
  include apache

  $docroot = $midonet_mem::params::mem_install_path
  $proxy_pass = [
    { 'path' => "/$midonet_mem::params::api_namespace",
      'url'  => "$midonet_mem::params::api_host"
    }
  ]

  apache::vhost { 'midonet-mem':
    port       => '80',
    docroot    => $docroot,
    proxy_pass => $proxy_pass
  }

}

