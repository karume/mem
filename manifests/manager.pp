# == Class: midonet_mem
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
# [api_host]
#   Configures the MidoNet REST API's host:port combination. This can be either
#   the API host's host name and Tomcat port, or if proxied, e.g via Apache,
#   the corresponding proxy host name and port.
#   e.g. "api_host": "http://host:port"
#
# [login_host]
#   Configures the authentication host's host:port combination. Usually your
#   authentication server, e.g. Keystone, is accessible from the same address as
#   the MidoNet REST API, so the host:port combination should be the same as for
#   the API host ("api_host"). Should the authentication server be located on a
#   different host then the MidoNet REST API, change this parameter accordingly.
#   e.g "login_host": "http://host:port"
#
# [trace_api_host]
#   Configures the trace requests management API host:port combination. It is
#   usually the same as the "api_host" but could be setup to run on a different
#   server. This can be either the API host's host name and Tomcat port, or if
#   proxied, e.g via Apache, the corresponding proxy host name and port.
#   e.g. "trace_api_host": "http://host:port"
#
# [traces_ws_url]
#   Configures the websocket endpoint host:port combination. This endpoint is
#   used by the Flow Tracing feature in Midonet Manager.
#   e.g. "trace_ws_url": "ws://host:port"
#
# [api_version]
#   The default value for the api_version is set to latest version. In case you
#   are using and older MidoNet REST API, change the version accordingly.
#   Note: The MidoNet Manager supports the following API versions: 1.8 and 1.9
#   e.g. "api_version": "1.9"
#
# [api_token]
#   If desired, auto-login can be enabled by setting the value of api_token to
#   your Keystone token.
#   e.g. "api_token": keystone_token
#
# [agent_config_api_host]
#   Configures the Agent Configuration API host:port combination. The Host is
#   usually the same as the Midonet REST API and the default port is 8459.
#   e.g. "agent_config_api_host": "http://host:port"
#
# [poll_enabled]
#   The Auto Polling will seamlessly refresh Midonet Manager data periodically.
#   It is enabled by default and can be disabled in Midonet Manager's Settings
#   section directly through the UI. This will only disable it for the duration
#   of the current session. It can also be disabled permanently by changing the
#   'poll_enabled' parameter to 'false'
#   e.g. "poll_enabled": true_or_false
#
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
# This class can be called by using 'include' and it will inherits the default
# data from 'midonet_mem::params' class or Hiera:
#
#   include ::midonet_mem::manager
#
# Data can be added to Hiera in order to override the default values specified
# in 'midonet_mem::params':
#
#   midonet_mem::manager::mem_package: 'midonet-manager'
#   midonet_mem::manager::mem_install_path: '/var/www/html/midonet-manager'
#   midonet_mem::manager::api_host: 'http://localhost:8080'
#   midonet_mem::manager::api_version: '1.9'
#   midonet_mem::manager::api_token: '999888777666'
#   midonet_mem::manager::api_namespace: 'midonet-api'
#   midonet_mem::manager::login_host: 'http://localhost:8080'
#   midonet_mem::manager::trace_api_host: 'http://localhost:8080'
#   midonet_mem::manager::traces_ws_url: 'http://localhost:8460'
#   midonet_mem::manager::agent_config_api_host: 'http://localhost:8459'
#   midonet_mem::manager::agent_config_api_namespace: 'conf'
#   midonet_mem::manager::poll_enabled: true
#
# Otherwise, it also can be called by using 'class' specifying parameters and
# values, which will override the default values specified in 'midonet_mem::params'
# class and Hiera:
#
#   class { '::midonet_mem::manager':
#     mem_package                => 'midonet-manager',
#     mem_install_path           => '/var/www/html/midonet-manager',
#     api_host                   => 'http://localhost:8080',
#     api_version                => '1.9',
#     api_token                  => '999888777666',
#     api_namespace              => 'midonet-api',
#     login_host                 => 'http://localhost:8080',
#     trace_api_host             => 'http://localhost:8080',
#     traces_ws_url              => 'http://localhost:8460',
#     agent_config_api_host      => 'http://localhost:8459',
#     agent_config_api_namespace => 'conf',
#     poll_enabled               => true,
#   }
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
class midonet_mem::manager (
# Midonet Manager installation options
  $mem_package                = $::midonet_mem::params::mem_package,
  $mem_install_path           = $::midonet_mem::params::mem_install_path,
# Midonet Manager configuration options
  $api_host                   = $::midonet_mem::params::api_host,
  $api_version                = $::midonet_mem::params::api_version,
  $api_token                  = $::midonet_mem::params::api_token,
  $api_namespace              = $::midonet_mem::params::api_namespace,
  $login_host                 = $::midonet_mem::params::login_host,
  $trace_api_host             = $::midonet_mem::params::trace_api_host,
  $traces_ws_url              = $::midonet_mem::params::traces_ws_url,
  $agent_config_api_host      = $::midonet_mem::params::agent_config_api_host,
  $agent_config_api_namespace = $::midonet_mem::params::agent_config_api_namespace,
  $poll_enabled               = $::midonet_mem::params::poll_enabled,
) inherits midonet_mem::params {

  package { 'midonet-manager':
    ensure  => installed,
    name    => $mem_package,
    require => Class['::midonet_mem::repository']
  }

  file { 'midonet-manager-config':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    path    => "${mem_install_path}/config/client.js",
    content => template("${module_name}/client.js.erb"),
    require => Package['midonet-manager']
  }

  include ::midonet_mem::vhost

}

