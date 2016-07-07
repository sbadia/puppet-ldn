# Module:: common
# Manifest:: init.pp
#
# Lorraine Data Network http://ldn-fai.net/
# Author:: Sebastien Badia (<seb@sebian.fr>)
# Date:: 2013-12-07 15:28:58 +0100
# Maintainer:: Sebastien Badia (<seb@sebian.fr>)
#

# Class:: common
#
#
class common {

  class {'dnsclient':
    nameservers => hiera_array('nameservers', undef),
    options     => 'UNSET',
    search      => hiera("domain"),
    domain      => hiera("domain"),
  }

  # TODO, apt-proxy

  # Remove apt-xapian-index (on low memory vm, xapian take a lot of RAM/CPU)
  # https://bugs.launchpad.net/ubuntu/+source/apt-xapian-index/+bug/363695
  package {'apt-xapian-index':
    ensure => purged,
  }

  # Setup timezone
  class {
    'timezone':
      timezone    => hiera("timezone"),
      autoupgrade => false;
  }

  class {'locales':
    default_locale => 'en_US.UTF-8 UTF-8',
    locales        => hiera("locales")
  }

  ensure_packages(['tmux','screen','netcat','htop','rsync','host','dmraid',
    'man-db','vim','zsh','bash','iputils-ping','dnsutils',
    'python-apt','aptitude','debian-goodies','molly-guard'])

  # TODO, sudo / sudo-ldap
  # TODO, sudo %puppetdev
  # TODO, ssh_auth_sock

  file {
    '/usr/local/bin/cronic':
      ensure => file,
      source => 'puppet:///modules/common/cronic',
      owner  => root,
      group  => root,
      mode   => '0755';
  }

  file {
    '/etc/alternatives/editor':
      ensure  => link,
      target  => '/usr/bin/vim',
      require => Package['vim'];
    '/bin/sh':
      ensure => link,
      target => '/bin/dash';
  }

  file {
    '/etc/hostname':
      ensure  => file,
      content => $::fqdn,
      owner   => root,
      group   => root,
      mode    => '0644',
      notify  => Exec['reload hostname'];
    '/etc/mailname':
      ensure  => file,
      content => $::fqdn,
      owner   => root,
      group   => root,
      mode    => '0644';
  }

  exec {
    'reload hostname':
      command     => '/bin/sh /etc/init.d/hostname.sh start',
      user        => root,
      refreshonly => true,
      logoutput   => on_failure;
  }

  # TODO, setup sources
  # TODO, setup ssh

  class {'::motd': template => 'common/motd.erb'; }

  # Avoid a strange bug with facter
  # Could not retrieve fact='selinux', resolution='<anonymous>'': Invalid argument - /proc/self/attr/current
  if $::selinux == 'false' {
    file {'/selinux/enforce': ensure => absent }
  }

} # Class:: common
