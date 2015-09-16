# == Class: midonet_mem
#
# Install and configure Midokura Enterprise MidoNet (MEM)
#
# === Parameters
# [api_namespace]
#   The default value for the api_namespace is set to midonet-api which usually
#   does not have to be changed.
#   Default value: "api_namespace": "midonet-api"
#
# [agent_config_api_namespace]
#   The default value for the 'agent_config_api_namespace' is set to 'conf'
#   which usually does not have to be changed.
#   Default value: "api_namespace": "conf"
#
# === Examples
#
# This class should be called by using 'include' if data is available in hiera:
#
#   include midonet_mem
#
# Otherwise, it must be called by using 'class' specifying parameters and
# values:
#
# class { '::midonet_mem':
#   mem_repo_user     => 'username',
#   mem_repo_password => 'password',
#   api_host          => 'http://localhost:8080',
# }
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

class midonet_mem (
# Midonet Manager installation options
  $mem_repo_user     = undef,
  $mem_repo_password = undef,
) inherits ::midonet_mem::params {

  if $mem_repo_user and $mem_repo_password {
    class { '::midonet_mem::repository':
      mem_repo_user     => $mem_repo_user,
      mem_repo_password => $mem_repo_password
    }
  } else {
    fail('You need to specify credentials: mem_repo_user and mem_repo_password.')
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

