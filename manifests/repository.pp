# == Class: midonet_mem::repository
#
# This class configures the needed repositories to be able to download and
# install Midokura Enterprise MidoNet packages for both Debian-like and
# RedHat-like OS
#
# === Parameters
#
# [*repo_user*]
#   The username of the Midokura Enterprise MidoNet repository
#
# [*repo_password*]
#   The password of the username for the Midokura Enterprise MidoNet repository
#
# === Examples
#
# This class cannot be called by using 'include' since both 'repo_user' and
# 'repo_password' params are mandatory to declare.
#
# Thus this class can be called by using 'class' and specifying the values for
# both params:
#
#  class { 'midonet_mem::repository':
#    repo_user     => 'username',
#    repo_password => 'password',
#  }
#
# Or instead, data can be added to Hiera:
#
#  midonet_mem::repository::repo_user: 'username'
#  midonet_mem::repository::repo_password: 'password'
#
#  class { 'midonet_mem::repository':
#    repo_user     => hiera('midonet_mem::repository::repo_user'),
#    repo_password => hiera('midonet_mem::repository::repo_password'),
#  }
#
# === Authors
#
# Midonet (http://midonet.org)
#
# === Copyright
#
# Copyright (c) 2015 Midokura SARL, All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
class midonet_mem::repository (
  $repo_user     = undef,
  $repo_password = undef,
) inherits midonet_mem::params {

  case $::osfamily {
    'Debian': {
      class { '::midonet_mem::repository::ubuntu':
        repo_user               => $repo_user,
        repo_password           => $repo_password,
        midonet_thirdparty_repo => $midonet_mem::params::midonet_thirdparty_repo,
        midonet_key             => $midonet_mem::params::midonet_key,
        midonet_stage           => $midonet_mem::params::midonet_stage,
      }
    }
    'RedHat': {
      class { '::midonet_mem::repository::centos':
        repo_user               => $repo_user,
        repo_password           => $repo_password,
        midonet_thirdparty_repo => $midonet_mem::params::midonet_thirdparty_repo,
        midonet_key             => $midonet_mem::params::midonet_key,
        manage_distro_repo      => $midonet_mem::params::manage_distro_repo,
        manage_epel_repo        => $midonet_mem::params::manage_epel_repo,
      }
    }
    default: {
      fail("Unsupported platform: midonet-${module_name} only supports RedHat-like and Debian-like OS")
    }
  }

}

