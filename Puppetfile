# Puppetfile
#
# Infrastucture Lorraine Data Network <benevoles@listes.ldn-fai.net>
#
#forge "https://forgeapi.puppetlabs.com" # prepare migration to API v3
forge "http://forge.puppetlabs.com"

# Forge Modules
mod 'sbadia/allknowingdns', '1.0.0'
mod 'eirc/account', '0.2.0'
mod 'markhellewell/aptcacherng', '0.1.7'
mod 'thomasvandoren/etckeeper', '0.0.9'
mod 'thias/bind', '0.5.1'
mod 'thias/postfix', '0.3.3'
mod 'ssm/munin', '0.0.5'
mod 'sbadia/bird', '0.0.5'
mod 'ghoneycutt/dnsclient', '3.1.0'
mod 'torian/ldap', '0.2.4'
mod 'saz/locales', '2.1.0'
mod 'sbadia/metche', '0.0.2'
mod 'adrien/network', '0.4.1'
#mod 'jvaubourg/nginxpack', '0.1.1'
mod 'saz/rsyslog', '3.3.0'
mod 'thias/sysctl', '0.3.2'
mod 'saz/sudo', '3.0.6'
mod 'saz/timezone', '3.0.1'
mod 'saz/motd', '2.1.0'
mod 'camptocamp/kmod', '0.1.2'
mod 'sbadia/checkmk', '1.0.4'
mod 'Aethylred/rrd', '0.1.3'

# Git Modules
# FIXME(sbadia): https://github.com/jfryman/puppet-inittab/pull/3
mod 'jfryman/inittab',
  :git => 'https://github.com/sbadia/puppet-inittab',
  :ref => 'bd514bae0861a57bb831ab2e23e87bda8c69bb27'
# FIXME(sbadia): not released yet
mod 'jvaubourg/nginxpack',
  :git => 'https://github.com/jvaubourg/puppetlabs-nginxpack',
  :ref => '50a0fc2bcd2d1365aed7e7c1e76accb7baee17e7'

## PuppetLabs
mod 'puppetlabs/apache', '1.1.1'
mod 'puppetlabs/apt', '1.7.0'
mod 'puppetlabs/concat', '1.1.0'
mod 'puppetlabs/mysql', '2.3.1'
mod 'puppetlabs/ntp', '3.1.2'
mod 'puppetlabs/stdlib', '4.3.2'
mod 'puppetlabs/vcsrepo', '1.1.0'

mod 'ldn',
  :git => 'gitldn:puppet/puppet-ldn.git'
