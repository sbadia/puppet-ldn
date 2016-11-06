# Module:: public
# Manifest:: apt.pp
#
# Lorraine Data Network http://ldn-fai.net/

class public::mta {

  include '::postfix::server'

  mailalias { 'root':
    ensure    => present,
    recipient => 'root@ldn-fai.net',
    notify    => Service['postfix'];
  }

}
