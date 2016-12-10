# Module:: public
# Manifest:: common.pp
#
# Lorraine Data Network http://ldn-fai.net/

# Class:: common
#
#
class public::common {

  # Internal
  include '::public::apt'

  # External (hiera for configuration)
  include '::dnsclient'
  include '::etckeeper'
  include '::locales'
  include '::rsyslog::client'
  include '::sudo'
  include '::timezone'
  include '::unattended_upgrades'

  # TODO, apt-proxy

  # Remove apt-xapian-index (on low memory vm, xapian take a lot of RAM/CPU)
  # https://bugs.launchpad.net/ubuntu/+source/apt-xapian-index/+bug/363695
  package {'apt-xapian-index':
    ensure => purged,
  }

  ensure_packages(['tmux','screen','netcat','htop','rsync','host','dmraid',
    'man-db','vim','zsh','bash','iputils-ping','dnsutils','logrotate',
    'python-apt','aptitude','debian-goodies','molly-guard','lrzip'])

  # TODO, backup user

  sudo::conf { 'ssh_auth_sock':
    priority => 90,
    content  => 'Defaults env_reset, env_keep += "SSH_AUTH_SOCK"',
  }

  sudo::conf { 'puppetdev':
    priority =>  10,
    content  => '%puppetdev ALL=(ALL) NOPASSWD: /usr/bin/puppet, /bin/mkdir, /bin/chown, /bin/rm',
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
      command     => "/usr/bin/hostnamectl set-hostname ${::fqdn}",
      user        => root,
      refreshonly => true,
      logoutput   => on_failure;
  }

  class {'::motd': template => 'public/common/motd.erb'; }

  # Avoid a strange bug with facter
  # Could not retrieve fact='selinux', resolution='<anonymous>'': Invalid argument - /proc/self/attr/current
  if $::selinux == 'false' {
    file {'/selinux/enforce': ensure => absent }
  }

} # Class:: common
