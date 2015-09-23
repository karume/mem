# == Class: midonet_mem::vhost
#
# This class installs apache2/httpd server and configures a custom virtualhost
# for midonet-manager.
#
# === Parameters
#
# [*apache_port*]
#  The TCP port where apache2/httpd server is listening on.
#  Note: this value has been defaulted to '80'
#
# [*docroot*]
#   The value for the virtualhost DocumentRoot directive.
#   Note: this value has been defaulted to '/var/www/html'
#
# [*servername*]
#   The value for the virtualhost ServerName directive.
#   Note: this value has been defaulted to "http://$::ipaddress"
#
# === Examples
#
# This class can be called by using 'include' and it will inherits the default
# data from 'midonet_mem::params' class or Hiera:
#
#   include ::midonet_mem::vhost
#
# Data can be added to Hiera in order to override the default values specified
# in 'midonet_mem::params':
#
#   midonet_mem::vhost::apache_port: '80'
#   midonet_mem::vhost::docroot: '/var/www/html'
#   midonet_mem::vhost::servername: 'http://example.org'
#
# Otherwise, it also can be called by using 'class' specifying parameters and
# values, which will override the default values specified in 'midonet_mem::params'
# class and Hiera:
#
#   class { 'midonet_mem::vhost':
#     apache_port => '80',
#     docroot     => '/var/www/html',
#     servername  => 'http://example.org',
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
class midonet_mem::vhost (
  $apache_port = $midonet_mem::params::apache_port,
  $docroot     = $midonet_mem::params::docroot,
  $servername  = $midonet_mem::params::servername,
  $proxy_pass = [
    { 'path' => "/$midonet_mem::params::api_namespace",
      'url'  => "$midonet_mem::params::api_host",
    },
  ],
  $directories = [
    { 'path'  => $docroot,
      'allow' => 'from all',
    },
  ],
) inherits midonet_mem::params {

  validate_string($apache_port)
  validate_string($docroot)
  validate_string($servername)
  validate_array($proxy_pass)
  validate_array($directories)

  include ::apache
  include ::apache::mod::headers

  apache::vhost { 'midonet-mem':
    port            => $apache_port,
    servername      => $servername,
    docroot         => $docroot,
    proxy_pass      => $proxy_pass,
    directories     => $directories,
    require         => Package["$midonet_mem::params::mem_package"],
  }

}

