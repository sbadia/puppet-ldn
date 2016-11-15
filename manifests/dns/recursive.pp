# Module:: public
# Manifest:: dns/autoritaire.pp
#
# Author:: Julien Vaubourg (<julien@vaubourg.com>)
# Date:: 2013-09-21 13:36:02 +0200
# Maintainer:: Julien Vaubourg (<julien@vaubourg.com>)
#
# Class:: public::dns::recursive inherits public::dns
#
#
class public::dns::recursive {

  include '::bind'

  bind::server::file { [
    'named.conf',

    # from named.conf
    'named.conf.options',

  ]:
    zonedir     => '/etc/bind/',
    owner       => 'bind',
    group       => 'bind',
    source_base => 'puppet:///modules/public/dns/recursive/bind/',
  }

}
