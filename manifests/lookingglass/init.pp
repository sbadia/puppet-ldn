# Module:: public::lookingglass
# Manifest:: init.pp

class public::lookingglass {

  package { 'python':
      ensure => installed,
  }
}
