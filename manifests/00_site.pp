node 'base' {
  include '::ldn::users'
}

# File bucket
filebucket { 'mainldn': server => 'zoidberg.ldn-fai.net' }
File { backup => 'mainldn' }

# Base path
Exec { path => '/usr/bin:/usr/sbin:/bin:/sbin' }

import '*.ldn-fai.net.pp'
