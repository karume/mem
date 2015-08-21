# == Class: midonet_mem::repository::centos
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

class midonet_mem::repository::centos (
  $mem_repo_user = undef,
  $mem_repo_password = undef,
  $mem_repo,
  $midonet_thirdparty_repo,
  $midonet_stage,
  $manage_distro_repo,
  $manage_epel_repo) {
    # Adding repository for CentOS
    notice('Adding midonet sources for RedHat-like distribution')

    $mem_repo = "http://${mem_repo_user}:${mem_repo_password}@yum.midokura.com/repo/v1.9/stable/RHEL/7/"
    $mem_key_url = "http://${mem_repo_user}:${mem_repo_password}@yum.midokura.com/repo/RPM-GPG-KEY-midokura"

    yumrepo { 'midokura_enterprise_midonet':
      baseurl  => "${mem_repo}/${::operatingsystemmajrelease}/${midonet_stage}",
      descr    => 'Midonet base repo',
      enabled  => 1,
      gpgcheck => 1,
      gpgkey   => $mem_key_url,
      timeout  => 60
    }

    if $manage_epel_repo == true {
      package { 'epel-release':
        ensure   => installed
      }
    }

    exec {'update-midonet-repos':
      command => '/usr/bin/yum clean all && /usr/bin/yum makecache'
    }

    Yumrepo<| |> -> Exec<| command == 'update-midonet-repos' |>
    Package<| |> -> Exec<| command == 'update-midonet-repos' |>

}

