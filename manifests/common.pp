# Module:: public
# Manifest:: common.pp
#
# Lorraine Data Network http://ldn-fai.net/
# Author:: Sebastien Badia (<seb@sebian.fr>)
# Date:: 2013-12-07 15:28:58 +0100
# Maintainer:: Sebastien Badia (<seb@sebian.fr>)
#

# Class:: common
#
#
class public::common {

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
    default_locale => 'en_US.UTF-8',
    locales        => hiera("locales")
  }

  ensure_packages(['tmux','screen','netcat','htop','rsync','host','dmraid',
    'man-db','vim','zsh','bash','iputils-ping','dnsutils',
    'python-apt','aptitude','debian-goodies','molly-guard'])

  # TODO, backup user

  include '::sudo'

  sudo::conf { 'ssh_auth_sock':
    priority => 90,
    content  => 'Defaults env_reset, env_keep += "SSH_AUTH_SOCK"',
  }

  sudo::conf { 'puppetdev':
    priority =>  10,
    content  => '%puppetdev ALL=(ALL) NOPASSWD: /usr/bin/puppet',
  }

  file {
    '/usr/local/bin/cronic':
      ensure => file,
      source => 'puppet:///modules/public/common/cronic',
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

  package { 'openssh-server': ensure => present; }
  service { 'ssh':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    enable     => true,
  }

  # Setup ssh
  # See ::private::common for other SSH configuration
  public::ssh::configline {
    'LoginGraceTime':
      value => '60';
    'UsePrivilegeSeparation':
      value => 'yes';
    'PermitEmptyPasswords':
      value => 'no';
    'PasswordAuthentication':
      value => 'no';
    'StrictModes':
      value => 'yes';
    'UseDNS':
      value => 'no';
    'MaxStartups':
      value => '10:30:60';
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

  class {'::motd': template => 'public/common/motd.erb'; }

  # Avoid a strange bug with facter
  # Could not retrieve fact='selinux', resolution='<anonymous>'': Invalid argument - /proc/self/attr/current
  if $::selinux == 'false' {
    file {'/selinux/enforce': ensure => absent }
  }

} # Class:: common
