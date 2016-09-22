# Module:: public
# Manifest:: dns.pp
#
# Author:: Julien Vaubourg (<julien@vaubourg.com>)
# Date:: 2013-09-21 13:36:02 +0200
# Maintainer:: Julien Vaubourg (<julien@vaubourg.com>)
#
# Class:: public::dns
#
#
class public::dns {
  include 'bind'
}
