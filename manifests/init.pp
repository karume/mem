# == Class: midonet_mem
#
# This class does not install nor configure Midokura Enterprise Midonet by
# itself, but includes the needed class calls for both midonet & midonet_mem
# Puppet modules in order to simplify and to serve as an example on how the
# installation would be.
#
# === Parameters
# [*repo_user*]
#   The username of the Midokura Enterprise MidoNet repository.
#
# [*repo_password*]
#   The password of the username for the Midokura Enterprise MidoNet repository
#
# === Examples
#
# This class cannot be called by using 'include' since both 'repo_user' and
# 'repo_password' params are mandatory to declare.
#
# Thus this class should be called by using 'class' and specifying the values
# for both params:
#
#  class { '::midonet_mem':
#    repo_user     => 'username',
#    repo_password => 'password',
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
class midonet_mem (
  $repo_user     = undef,
  $repo_password = undef,
) inherits ::midonet_mem::params {

  validate_string($repo_user)
  validate_string($repo_password)

  if $repo_user and $repo_password {
    class { '::midonet_mem::repository':
      repo_user     => $repo_user,
      repo_password => $repo_password
    }
  } else {
    fail('You need to specify credentials: repo_user and repo_password.')
  }

  include ::midonet_mem::manager
  include ::midonet_mem::vhost

  # Add zookeeper
  class { '::midonet::zookeeper': }

  # Add cassandra
  class { '::midonet::cassandra': }

  # Add midonet-agent
  class { '::midonet::midonet_agent':
    zk_servers => [{
        'ip' => $::ipaddress}
        ],
    require    => [Class['::midonet::cassandra'], Class['::midonet::zookeeper']]
  }

  # Add midonet-api
  class { '::midonet::midonet_api':
    zk_servers =>  [{'ip' => $::ipaddress}]
  }

  # Add midonet-cli
  class { '::midonet::midonet_cli': }

}

