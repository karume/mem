class midonet_mem::vhost {

  include apache
  apache::vhost { 'midonet-mem':
    port                     => '80',
    docroot                  => '/var/www/html/midonet-manager',
    redirect_source          => '/midonet-api',
    proxy_dest               => 'http://localhost:8080/midonet-api',
    proxy_dest_reverse_match => '/midonet-api'
  }

}

