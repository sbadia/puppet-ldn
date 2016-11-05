# Module:: public
# Manifest:: logger.pp
#
# Lorraine Data Network http://ldn-fai.net/

class public::logger {
  include '::rsyslog::server'
  $log_path = hiera('log_path')

  cron { 'compress old logs':
    user    => root,
    command => "/usr/bin/find ${log_path} -type f -mtime +7 -exec /bin/gzip -q {} \;",
    minute  => '0',
    hour    => '0',
    weekday => '0',
  }
}
