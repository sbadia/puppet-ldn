# Module:: public::lookingglass
# Manifest:: lgproxy.pp

# Sources
# git clone https://github.com/sileht/bird-lg -C /opt/

class public::lookingglass::lgproxy {

  user { 'lgproxy':
    ensure => present,
    system => true,
  }

  file { '/etc/systemd/system/lgproxy.service':
    ensure  => file,
    owner   => root,
    group   => staff,
    mode    => '0755',
    source  => 'puppet:///modules/public/lookingglass/lgproxy/lgproxy.service',
    notify  => Service['lgproxy'],
    require => User['lgproxy'],
  }

  service { 'lgproxy':
    ensure  => running,
    enable  => true,
    require => File['/etc/systemd/system/lgproxy.service'],
  }

  file { '/opt/bird-lg/':
    ensure => directory,
    owner  => root,
    group  => staff,
    mode   => '0755',
  }

  file { '/opt/bird-lg/lgproxy.cfg':
    ensure => file,
    owner  => root,
    group  => staff,
    mode   => '0644',
    source => "puppet:///modules/private/lookingglass/lgproxy/lgproxy-${hostname}.cfg",
    notify => Service['lgproxy'],
  }

  file { '/opt/bird-lg/lgproxy.py':
    ensure  => file,
    owner   => root,
    group   => staff,
    mode    => '0755',
    notify  => Service['lgproxy'],
    #require => [
    #  Package['bird6'],
    #  Package['bird'],
    #],
  }

  file { [ '/var/run/bird/bird6.ctl', '/var/run/bird/bird.ctl' ]:
    owner   => 'root',
    group   => 'lgproxy',
    #require => [
    #  Package['bird6'],
    #  Package['bird'],
    #],
  }
}
