# Define:: public::dns::slave_zone
#
# Args::
#   $master  = dns master
#   $zonedir = slave zone dir
#
define public::dns::slave_zone(
  $master      = '0.0.0.0',
  $zonedir     = '/etc/bing',
  $slave_zones = [],
) {

  file {
    '/etc/bind/named.conf.local':
      ensure  => file,
      content => template('public/dns/slave.conf.erb'),
      owner   => 'bind',
      group   => 'bind',
      mode    => '0644',
  }

} # Define: defname
