# Module:: public
# Manifest:: apt.pp
#
# Lorraine Data Network http://ldn-fai.net/
# Author:: Sebastien Badia (<seb@sebian.fr>)

class public::apt {
  # setup http://ftp.fr.debian.org/{debian,ubuntu}
  $downcase_lsbdistid = downcase($::lsbdistid)

  apt::source { "${downcase_lsbdistid}_${::lsbdistcodename}":
    location    => "http://ftp.fr.debian.org/${downcase_lsbdistid}/",
    release     => $::lsbdistcodename,
    repos       => 'main contrib non-free',
    include_src => true,
  }

  apt::source { "${downcase_lsbdistid}_${::lsbdistcodename}_security":
    location          => 'http://security.debian.org',
    release           => "${::lsbdistcodename}/updates",
    repos             => 'main',
    required_packages => 'debian-keyring debian-archive-keyring',
    include_src       => true,
  }

  apt::source { "${downcase_lsbdistid}_${::lsbdistcodename}_updates":
    location    => "http://ftp.fr.debian.org/${downcase_lsbdistid}/",
    release     => "${::lsbdistcodename}-updates",
    repos       => 'main',
    include_src => true,
  }

  apt::source { "${downcase_lsbdistid}_${::lsbdistcodename}_backports":
    location    => "http://ftp.fr.debian.org/${downcase_lsbdistid}/",
    release     => "${::lsbdistcodename}-backports",
    repos       => 'main',
    include_src => true,
  }

}
