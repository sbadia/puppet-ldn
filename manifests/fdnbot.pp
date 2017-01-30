# Module:: public
# Manifest:: fdnbot.pp

class public::fdnbot {

  ensure_packages(['libmail-sendmail-perl','libbot-basicbot-perl','libmime-tools-perl'])

  user { 'fdnbot':
    ensure => present,
    system => true,
  }

  file { '/etc/systemd/system/fdnbot.service':
    ensure  => file,
    owner   => root,
    group   => staff,
    mode    => '0755',
    source  => 'puppet:///modules/public/fdnbot/fdnbot.service',
    notify  => Service['fdnbot'],
    require => User['fdnbot'],
  }

  service { 'fdnbot':
    ensure  => running,
    enable  => true,
    require => File['/etc/systemd/system/fdnbot.service'],
  }

  file {
    '/usr/local/bin/fdnbot.pl':
      ensure  => file,
      mode    => '0755',
      owner   => 'fdnbot',
      group   => 'fdnbot',
      source  => 'puppet:///modules/public/fdnbot/fdnbot.pl',
      notify  => Service['fdnbot'],
      require => Package['libmail-sendmail-perl'];
    '/var/www/fdn.ldn-fai.net':
      ensure => directory,
      owner  => 'fdnbot',
      group  => 'fdnbot',
      mode   => '0755';
    '/var/www/fdn.ldn-fai.net/index.html':
      ensure => file,
      owner  => 'fdnbot',
      group  => 'fdnbot',
      mode   => '0644';
  }

}
