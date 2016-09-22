# Module:: public
# Manifest:: dns/authoritative.pp
#
# Author:: Julien Vaubourg (<julien@vaubourg.com>)
# Date:: 2013-09-21 13:36:02 +0200
# Maintainer:: Julien Vaubourg (<julien@vaubourg.com>)
#              Sebastien Badia (<seb@sebian.fr>)

define public::dns::zone {
  bind::server::file {"db.$title":
    zonedir     => '/etc/bind/zones',
    owner       => 'bind',
    group       => 'bind',
    source_base => 'puppet:///modules/public/authoritative/zones/',
    require     => File['/etc/bind/zones'],
  }
}
