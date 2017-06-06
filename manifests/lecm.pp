# Module:: public
# Manifest:: lecm.pp

class public::lecm {
  package { 'lecm':
    ensure => installed,
  }

  file { '/etc/lecm.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => "puppet:///modules/private/lecm/${::fqdn}/lecm.conf",
    require => [
      Package['lecm'],
      File['/etc/letsencrypt']
    ]
  }

  file { '/etc/letsencrypt':
    ensure => directory,
  }
}
