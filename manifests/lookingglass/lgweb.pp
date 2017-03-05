# Module:: public::lookingglass
# Manifest:: lgweb.pp

# Sources
# git clone https://github.com/sileht/bird-lg -C /opt/

class public::lookingglass::lgweb(
  $domains = ['lg.ldn-fai.net','lg.as60197.net'],
  $ssl_cert_source = '/etc/letsencrypt/pem/lg.ldn-fai.net.pem',
  $ssl_key_source = '/etc/letsencrypt/private/lg.ldn-fai.net.key',
  $ssl_dhparam_source = '/etc/letsencrypt/dhparam.pem',
) {

  package { [ 'python-dnspython', 'python-pydot', 'python-flask' ]:
    ensure => installed,
  }

  nginxpack::vhost::redirection { 'https-lgweb':
    domains  => $domains,
    to_https => true,
  }
  nginxpack::vhost::proxy { 'lgweb':
    domains            => $domains,
    to_domain          => '127.0.0.1',
    to_port            => 5000,
    https              => true,
    ssl_cert_source    => $ssl_cert_source,
    ssl_key_source     => $ssl_key_source,
    ssl_dhparam_source => $ssl_dhparam_source,
  }

  user { 'lgweb':
    ensure => present,
    shell  => '/usr/sbin/nologin',
    system => true,
  }

  file { '/etc/systemd/system/lgweb.service':
    ensure  => file,
    owner   => root,
    group   => staff,
    mode    => '0755',
    source  => 'puppet:///modules/public/lookingglass/lgweb/lgweb.service',
    notify  => Service['lgweb'],
    require => User['lgweb'],
  }

  service { 'lgweb':
    ensure  => running,
    enable  => true,
    require => File['/etc/systemd/system/lgweb.service'],
  }

  file { '/opt/bird-lg/':
    ensure => directory,
    owner  => root,
    group  => staff,
    mode   => '0755',
  }

  file { '/opt/bird-lg/lg.cfg':
    ensure => file,
    owner  => root,
    group  => staff,
    mode   => '0644',
    source => 'puppet:///modules/private/lookingglass/lgweb/lgweb.cfg',
    notify => Service['lgweb'],
  }

  file { '/opt/bird-lg/lg.py':
    ensure => file,
    owner  => root,
    group  => staff,
    mode   => '0755',
    notify => Service['lgweb'],
  }
}
