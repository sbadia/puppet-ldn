# Module:: public
# Manifest:: dns/tls_proxy.pp
#
# Author:: Gabriel Corona (<gabriel.corona@enst-bretagne.fr>)
# Date:: 2015-02-16 00:16:42 +0200
# Maintainer:: Gabriel Corona (<gabriel.corona@enst-bretagne.fr>)
#
# Class:: public::dns::tls_proxy inherits public::dns
#
#
class public::dns::tls_proxy {

  # Mot this into a stunnel module:
  ensure_packages(['stunnel4'])

  service{'stunnel4':
    ensure => running,
    enable => true,
  }

  Package['stunnel4'] ->
  file{'/etc/default/stunnel4':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => 'u=r,go=r',
    source => 'puppet:///modules/public/dns/tls_proxy/stunnel'
  } ~> Service['stunnel4']

  Package['stunnel4'] ->
  file{'/etc/stunnel/dns.conf':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => 'u=r,go=r',
    source => 'puppet:///modules/public/dns/tls_proxy/dns.conf'
  } ~> Service['stunnel4']

  Package['stunnel4'] ->
  file{'/etc/stunnel/dns.pem':
    ensure  => file,
    source  => "puppet:///private/dns.pem",
    owner   => 'root',
    group   => 'root',
    mode    => '0640';
  } ~> Service['stunnel4']

}
