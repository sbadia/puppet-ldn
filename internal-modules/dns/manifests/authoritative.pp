# Module:: dns
# Manifest:: authoritative.pp
#
# Author:: Julien Vaubourg (<julien@vaubourg.com>)
# Date:: 2013-09-21 13:36:02 +0200
# Maintainer:: Julien Vaubourg (<julien@vaubourg.com>)
#              Sebastien Badia (<seb@sebian.fr>)
#
# Class:: dns::authoritative inherits dns
#
#
class dns::authoritative inherits dns {

  package { 'zonecheck':
    ensure => installed,
  }

  # Configurations
  bind::server::file { [
    'named.conf',
    # from named.conf
    'acl.conf',
    'named.conf.local',
    'named.conf.options',
    'divers.conf',
    'adherents.conf',
  ]:
    zonedir     => '/etc/bind',
    owner       => 'bind',
    group       => 'bind',
    source_base => 'puppet:///modules/ldn/authoritative/confs/',
    # require     => File['/etc/all-knowing-dns.conf'],
  }

  file {
    '/etc/bind/zones':
      ensure => directory,
      owner  => 'bind',
      group  => 'bind',
  }

  $zones = hiera_hash('zones', {})
  create_resources(dns::zone, $zones)


} # Class:: dns::authoritative inherits dns
