class midonet_mem::vhost {

  include ::midonet_mem::params
  include ::apache
  include ::apache::mod::headers

  $docroot = $midonet_mem::params::mem_install_path
  $mem_package = $midonet_mem::params::mem_package
  $proxy_pass = [
    { 'path' => "/$midonet_mem::params::api_namespace",
      'url'  => "$midonet_mem::params::api_host"
    }
  ]

  apache::vhost { 'midonet-mem':
    port            => '80',
    servername      => "http://$::ipaddress",
    docroot         => '/var/www/html',
    proxy_pass      => $proxy_pass,
    redirect_source => '/midonet-manager',
    redirect_dest   => $docroot,
    directories     => [
      { 'path'      => '/var/www/html',
        'allow'     => 'from all',
      },
    ],
    require         => Package["$mem_package"],
  }

}

