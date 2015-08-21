# == Class: midonet_mem::repository::ubuntu
# NOTE: don't use this class, use midonet_mem::repository(::init) instead
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
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

class midonet_mem::repository::ubuntu (
  $mem_repo_user = undef,
  $mem_repo_password = undef,
  $midonet_stage,
  $midonet_thirdparty_repo,
  $midonet_key) {
    notice('Adding MEM sources for Debian-like distribution')

    include apt
    include apt::update

    # Update the package list each time a package is defined. That takes
    # time, but it ensures it will not fail for out of date repository info
    Exec['apt_update'] -> Package<| |>

    $mem_repo = "http://${mem_repo_user}:${mem_repo_password}@apt.midokura.com/midonet/v1.9/stable"
    $mem_key_url = "https://${mem_repo_user}:${mem_repo_password}@apt.midokura.com/packages.midokura.key"

    apt::source { 'midokura_enterprise_midonet':
      comment     => 'Midokura Enterprise MidoNet apt repository',
      location    => $mem_repo,
      release     => $midonet_stage,
      key         => $midonet_key,
      key_content  => "puppet:///${module_name}/mem.key",
      include_src => false,
    }

    # Dummy exec to wrap apt_update
    exec {'update-midonet-repos':
      command => '/bin/true',
      require => [Exec['apt_update'],
                  Apt::Source['midokura_enterprise_midonet']]
    }

    Apt::Source<| |> -> Exec<| command == 'update-midonet-repos' |>

}

