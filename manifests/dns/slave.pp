# Module:: public
# Manifest:: dns/slave.pp
#
# Lorraine Data Network http://ldn-fai.net/

# Class:: public::dns::slave
#
#
class public::dns::slave(
  $slave_name = '',
  $master = '',
  $zonedir = '/var/cache/bind',
  $zones = [],
  $zones_source_base = '',
  $named_conf_source = '',
) {

  include '::bind'

  public::dns::slave_zone { $slave_name:
    slave_zones => $zones,
    master      => $master,
    zonedir     => $zonedir,
  }

  bind::server::file {[
    'named.conf',
    'acl.conf',
  ]:
    zonedir     => '/etc/bind',
    owner       => 'bind',
    group       => 'bind',
    source_base => $zones_source_base,
  }

  bind::server::file {'named.conf.options':
    zonedir => '/etc/bind',
    owner   => 'bind',
    group   => 'bind',
    source  => $named_conf_source,
  }


} # Class:: dns::slave inherits dns
