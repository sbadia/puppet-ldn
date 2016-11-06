# Module:: public
# Manifest:: dns/authoritative.pp
#
# Lorraine Data Network http://ldn-fai.net/

define public::dns::zone {
  bind::server::file {"db.${title}":
    zonedir     => '/etc/bind/zones',
    owner       => 'bind',
    group       => 'bind',
    source_base => 'puppet:///modules/private/authoritative/zones/',
    require     => File['/etc/bind/zones'],
  }
}
