# Module:: public::lookingglass
# Manifest:: lgweb.pp

# Sources
# git clone https://github.com/sileht/bird-lg -C /opt/

class public::lookingglass::lgweb {

  package { [ 'python-memcache', 'python-dnspython', 'python-pydot', 'python-flask', 'whois' ]:
    ensure => installed,
  }

  nginxpack::vhost::proxy { 'lgweb':
    domains   => [ 'lg.ldn-fai.net', 'lg.as60197.net' ],
    to_domain => '127.0.0.1',
    to_port   => 5000,
  }

  user { 'lgweb':
    ensure => present,
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

  file { '/opt/bird-lg/lgweb.cfg':
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
