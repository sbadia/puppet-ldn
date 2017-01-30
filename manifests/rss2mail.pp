# Si cela ne fonctionne pas, c'est sur Petit qu'il faut tapper !
# Juin 2014

class public::rss2mail($list, $feed)  {

  # Vars (put in hiera ?)
  $user = 'rss2mail'
  $home_user = '/home/rss2mail'

  # Valid for Debian 7
  if ($::operatingsystem =~ /Debian/) and ($::operatingsystemrelease =~ /^8/) {
    # Install "rrr2email"
    package { ['rss2email']:
      ensure => installed,
    }

    # User creation
    user { 'user_rss2mail':
      ensure => present,
      name   => $user,
      home   => $home_user,
    } ->
    # home user creation
    file { $home_user:
      ensure  => 'directory',
      owner   => $user,
      group   => $user,
      mode    => '0760',
      require => User['user_rss2mail'],
    } ->

    # Check if existing conf else create it
    # "/usr/bin/r2e new $list" : declare mail adress target
    # "/usr/bin/r2e add $feed" add feed
    # "/usr/bin/r2e run" send a mail for each new entry in feed
    # " --no-send" no send. Useful the first time
    exec { 'rss2emailconf':
      creates     => "${home_user}/.rss2email/feeds.dat",
      user        => $user,
      environment => ["HOME=${home_user}"],
      command    => "/usr/bin/r2e new $list && /usr/bin/r2e add main $feed && /usr/bin/r2e run --no-send",
      # command     => "/usr/bin/r2e new ${list} && /usr/bin/r2e add main ${feed} && /usr/bin/r2e run",
      require     => [ Package['rss2email'], User['user_rss2mail'], File[$home_user] ],
    } ->
    # Schedule process "/usr/bin/r2e run"
    cron { 'r2e: use for automatic mailing a rss feed':
      command => '/usr/bin/r2e run',
      user    => $user,
      hour    => '20',
      minute  => '02',
      require => User['user_rss2mail'],
    }

  } else {
    notify {"[Error] OS not supported (${::osfamily} - ${::operatingsystemrealease})":}
  }
}
