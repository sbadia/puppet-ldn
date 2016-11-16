# Module:: public
# Manifest:: dns/reverse6.pp
#
# Author:: Julien Vaubourg (<julien@vaubourg.com>)
# Date:: 2013-09-21 13:36:02 +0200
# Maintainer:: Julien Vaubourg (<julien@vaubourg.com>)
#
# Class:: dns::reverse6 inherits dns
#
#
class public::dns::reverse6 {

  class { 'allknowingdns':
    listen         => ['2001:913::6','80.67.188.171'],
    network        => '2001:913::/32',
    address        => 'rev6.ldn-fai.net',
    address_prefix => 'UNSET',
  }

}
