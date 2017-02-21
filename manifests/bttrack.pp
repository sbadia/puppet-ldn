# Module:: public
# Manifest:: bttrack.pp

class public::bttrack(
  $port = 6969,
  $ipv6_enabled = 0,
  $ipv6_binds_v4 = 0,
  $bind = '',
  $logfile = '/var/log/bttrack.log',
  $dfile = '/var/run/bttrack.state',
  $allowed_dir = '/var/lib/bttrack',
  $nat_check = 0,
) {

  package { 'bittornado':
    ensure => installed,
  }

  file { '/etc/systemd/system/bttrack.service':
    ensure  => file,
    owner   => root,
    group   => staff,
    mode    => '0755',
    content => template('public/bttrack/bttrack.service.erb'),
    notify  => Service['bttrack'],
    require => User['bttrack'],
  }

  user { 'bttrack':
    ensure  => present,
    system  => true,
    comment => 'Bittorent Tracker User',
    shell   => '/usr/sbin/nologin',
  }

  service { 'bttrack':
    ensure  => running,
    enable  => true,
    require => File['/etc/systemd/system/bttrack.service'],
  }

  file { $allowed_dir:
    ensure => directory,
    owner  => 'bttrack',
    group  => 'bttrack',
    mode   => '0755',
  }

}
