class factorio::user {
  $factorio_home = $factorio::factorio_home
  user { 'factorio':
    ensure  => present,
    comment => '',
    home    => $factorio_home,
  }
  file { $factorio_home:
    ensure => 'directory',
    owner  => 'factorio',
    group  => 'factorio',
  }
}
