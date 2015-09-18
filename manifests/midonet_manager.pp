## == Class: midonet_mem::midonet_manager
#
# Install and configure Midokura Enterprise MidoNet (MEM)
#
# === Parameters
#
# [mem_package]
#   Name of the Midokura Enterprise MidoNet (MEM) package
#
# [mem_install_path]
#   Installation path of the Midokura Enterprise MidoNet (MEM) package
#
class midonet_mem::midonet_manager (
  $mem_package      = $midonet_mem::params::mem_package,
  $mem_install_path = $midonet_mem::params::mem_install_path,
) inherits midonet_mem::params {

  package { 'midonet-manager':
    ensure  => installed,
    name    => $mem_package,
    require => Class['::midonet_mem::repository']
  } ->

  file { 'midonet-manager-config':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    path    => "${mem_install_path}/config/client.js",
    content => template("${module_name}/client.js.erb"),
    require => Package['midonet-manager']
  }
}

