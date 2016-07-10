# Module:: dns
# Manifest:: init.pp
#
# Author:: Julien Vaubourg (<julien@vaubourg.com>)
# Date:: 2013-09-21 13:36:02 +0200
# Maintainer:: Julien Vaubourg (<julien@vaubourg.com>)
#
# Class:: ldn::dns
#
#
class ldn::dns {
  include 'bind'
}
