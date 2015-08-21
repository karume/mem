# == Class: midonet_mem::repository
#
# Full description of class midonet_mem here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the function of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'midonet_mem':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2015 Your name here, unless otherwise noted.

class midonet_mem::repository (
  $mem_repo_user = undef,
  $mem_repo_password = undef
) {

  include ::midonet_mem::params

  case $::osfamily {
    'Debian': {
      class { '::midonet_mem::repository::ubuntu':
        mem_repo_user           => $mem_repo_user,
        mem_repo_password       => $mem_repo_password,
        midonet_thirdparty_repo => $midonet_mem::params::midonet_thirdparty_repo,
        midonet_key             => $midonet_mem::params::midonet_key,
        midonet_stage           => $midonet_mem::params::midonet_stage,
      }
    }
    'RedHat': {
      class { '::midonet_mem::repository::centos':
        mem_repo_user           => $mem_repo_user,
        mem_repo_password       => $mem_repo_password,
        midonet_thirdparty_repo => $midonet_mem::params::midonet_thirdparty_repo,
        midonet_key             => $midonet_mem::params::midonet_key,
        midonet_stage           => $midonet_mem::params::midonet_stage,
        manage_distro_repo      => $midonet_mem::params::manage_distro_repo,
        manage_epel_repo        => $midonet_mem::params::manage_epel_repo,
      }
    }
    default: {
      fail("Unsupported platform: midonet-${module_name} only supports RedHat-like and Debian-like OS")
    }
  }

}

