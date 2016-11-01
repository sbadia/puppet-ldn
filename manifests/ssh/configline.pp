# Module:: public::ssh
# Manifest:: configline.pp
#
# Author:: Sebastien Badia (<seb@sebian.fr>)
# Date:: 2013-08-25 20:15:45 +0200
# Maintainer:: Sebastien Badia (<seb@sebian.fr>)
#

# Define:: public::ssh::configline
# Args::
#   $ensure = present,
#   $value  = false,
#
define public::ssh::configline(
  $ensure = present,
  $value = false
) {

  Augeas {
    context => '/files/etc/ssh/sshd_config',
    notify  => Service['ssh'],
  }

  case $ensure {
    present: {
      augeas { "sshd_config_${name}":
        changes => "set ${name} ${value}",
        onlyif  => "get ${name} != ${value}",
      }
    }
    add: {
      augeas { "sshd_config_${name}":
        onlyif  => "get ${name}[. = '${value}'] != ${value}",
        changes => [
          "ins ${name} after ${name}[last()]",
          "set ${name}[last()] ${value}"
        ],
      }
    }
    absent: {
      augeas { "sshd_config_${name}":
        changes => "rm ${name}",
        onlyif  => "get ${name}",
      }
    }
    default: {
      fail("ensure value must be present, add or absent, not ${ensure}")
    }
  }
} # Define: public::ssh::configline
