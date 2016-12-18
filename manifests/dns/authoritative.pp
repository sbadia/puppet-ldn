# Module:: public
# Manifest:: dns/authoritative.pp
#
# Lorraine Data Network http://ldn-fai.net/

# Class:: public::dns::authoritative
#
#
class public::dns::authoritative(
  $zones = []
) {

  include '::bind'

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
    source_base => 'puppet:///modules/private/authoritative/confs/',
  }

  file {
    '/etc/bind/zones':
      ensure => directory,
      owner  => 'bind',
      group  => 'bind',
  }

  create_resources(public::dns::zone, $zones)

} # Class:: public::dns::authoritative
