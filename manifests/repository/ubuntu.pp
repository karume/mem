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
  $repo_user = undef,
  $repo_password = undef,
  $midonet_stage,
  $midonet_thirdparty_repo,
  $midonet_key) {
    notice('Adding MEM sources for Debian-like distribution')

    include apt
    include apt::update

# This is the ugliest approach ever, key_content only accepts an string as an
# option :(
# And we have to use key_content in the first place because 'key_source' does
# not allow to use credentials within an https URI, even though it was fixed
# in theory: https://tickets.puppetlabs.com/browse/MODULES-1119
#
# key_content: Supplies the entire GPG key. Useful in case the key can't be
# fetched from a remote location and using a file resource is inconvenient.
# Valid options: a string. Default: undef. Note This parameter is deprecated
# and will be removed in a future release.
#
# https://github.com/puppetlabs/puppetlabs-apt#define-aptkey

    $key_content = "-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1

mI0ETb6aOgEEAMVw8Vnwk+zpDtsc0gSW10JEe48zKr2vpl9tQgWAFOPgOA1NglYM
w/xT6Rns7CrYxPR0cb3DeMFtFdMkfWXO0R6x4yHrozMDY/DpvwgYQclIIbcYYe0p
83nlBp793D2dSq60HWuXJu3oi0wQQuR0/jTmOnjxzCzu5jKdJeXihl95ABEBAAG0
Jk1pZG9rdXJhIChNaWRva3VyYSkgPGluZm9AbWlkb2t1cmEuanA+iLgEEwECACIF
Ak2+mjoCGwMGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAAoJEGezjToFQxTNAp0D
/2c+PLnRFzEXCztXT+05xoO1mPzpm3x2p5ecVPGHR8IxhozlN9DDGDdnvNfMOhi6
nv/G2l86+9Fj8Dz01ne0RZzZHSS1DF/zb6dMYrPJqiT1DXKH0Y73OL/+M7rsutEq
0B/DKhjdBfFPutk3gerEUZPNfIhScE3tnwCnVGJKPQbFuI0ETb6aOgEEANLJK3gm
Xrsp1VKnt663RoxZgoFQgQ6wHaZZWhULTteafjoThX9tj7FidR2+7qJLwpa57M9d
rib4OlbW+rE4PW199/Uqfy86gLv76Q2GZMpzaYB1ZZow0Ny1RTCwh7apkhR/8fCU
pq37aODQ4YwBpZC54iXVKfcntpdJFoObIqXtABEBAAGInwQYAQIACQUCTb6aOgIb
DAAKCRBns406BUMUzfzOBACKx4jChKTAl6HfldOxVN7o8DQpd5rgkHIEj062ym4Z
q5t2v3oaz0H0P2WV66MAhOujgX0V1duZi8fKHdIsdk0nvEa/mV0QS6pEAeZh+dbL
kKyu1J4MSi5l+L+te5XjYBGpoRa3ZGrIR3CkA0oQDCOh312SrcH6Tn9RBPChVSig
zg==
=zF5K
-----END PGP PUBLIC KEY BLOCK-----"

    # Update the package list each time a package is defined. That takes
    # time, but it ensures it will not fail for out of date repository info
    Exec['apt_update'] -> Package<| |>

    $mem_repo = "http://${repo_user}:${repo_password}@apt.midokura.com/midonet/v1.9/stable"

    apt::source { 'midokura_enterprise_midonet':
      comment     => 'Midokura Enterprise MidoNet apt repository',
      location    => $mem_repo,
      release     => $midonet_stage,
      key         => $midonet_key,
      key_content => $key_content,
      include_src => false
    }

    # Dummy exec to wrap apt_update
    exec {'update-mem-repos':
      command => '/bin/true',
      require => [Exec['apt_update'],
                  Apt::Source['midokura_enterprise_midonet']]
    }

    Apt::Source<| |> -> Exec<| command == 'update-midonet-repos' |>

}

