# Module:: public
# Manifest:: deluser.pp

define public::deluser {

  user { $name:
    ensure => absent,
    notify => Exec["backup ~${name} before remove"],
  }
  exec { "backup ~${name} before remove":
    command     => "/bin/tar czf ${name}.tgz ${name}",
    cwd         => '/home',
    user        => root,
    refreshonly => true,
    onlyif      => "/usr/bin/test -d /home/${name}",
    logoutput   => on_failure,
  }
}
