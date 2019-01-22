class factorio::updater{
  $factorio_home = $factorio::factorio_home
  $world_name = $factorio::world_name
  Exec { path => '/bin/:/sbin/:/usr/bin/:/usr/sbin/' }

  vcsrepo { "${factorio_home}/factorio-updater":
    ensure   => present,
    user     => 'factorio',
    group    => 'factorio',
    provider => git,
    source   => 'https://github.com/narc0tiq/factorio-updater.git',
  }
  package { 'python-requests':
    ensure  => installed,
  }
  exec { 'factorio-updater':
    onlyif  => "${factorio_home}/factorio-updater/update_factorio.py -da ${factorio_home}/factorio/bin/x64/factorio",
    command => "${factorio_home}/factorio-updater/update_factorio.py -a ${factorio_home}/factorio/bin/x64/factorio",
    notify  => Service["factorio@${world_name}"],
  }

}
