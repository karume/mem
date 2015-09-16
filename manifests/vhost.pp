class midonet_mem::vhost (
  $apache_port = $midonet_mem::params::apache_port,
  $servername  = $midonet_mem::params::servername,
  $docroot     = $midonet_mem::params::docroot,
  $mem_package = $midonet_mem::params::mem_package,
  $mem_path    = $midonet_mem::params::mem_install_path,
  $proxy_pass = [
    { 'path' => "/$midonet_mem::params::api_namespace",
      'url'  => "$midonet_mem::params::api_host",
    },
  ],
) inherits midonet_mem::params {

  include ::apache
  include ::apache::mod::headers

  apache::vhost { 'midonet-mem':
    port            => $apache_port,
    servername      => $servername,
    docroot         => $docroot,
    proxy_pass      => $proxy_pass,
    redirect_source => '/midonet-manager',
    redirect_dest   => $mem_path,
    directories     => [
      { 'path'  => '/var/www/html',
        'allow' => 'from all',
      },
    ],
    require         => Package["$mem_package"],
  }

}

