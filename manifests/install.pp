class factorio::install {
  $world_name = $factorio::world_name
  $factorio_home = $factorio::factorio_home
  Exec { path => '/bin/:/sbin/:/usr/bin/:/usr/sbin/' }

  $required_packages = [ 'wget', 'unzip' ]
    package { $required_packages:
    ensure => installed,
  }
  exec { 'download':
    command => "wget -O ${factorio_home}/server.tar.gz https://factorio.com/get-download/latest/headless/linux64",
    unless  => "test -f ${factorio_home}/server.tar.gz",
  }
  exec { 'extract':
    command => 'tar xvf server.tar.gz',
    cwd     => '/home/factorio',
    unless  => "test -d ${factorio_home}/factorio",
  }
  file { "${factorio_home}/ensure_permissions.py":
    ensure => file,
    owner  => 'factorio',
    group  => 'factorio',
    mode   => '0644',
    source => 'puppet:///modules/factorio/ensure_permissions.py'
  }
  exec { 'factorio_chown':
    command => "chown -R factorio:factorio ${factorio_home}",
    unless  => "python ${factorio_home}/ensure_permissions.py",
  }
  file { "${factorio_home}/factorio/data/map-gen-settings.${world_name}.json":
    ensure  => file,
    owner   => 'factorio',
    group   => 'factorio',
    mode    => '0644',
    replace => 'no',
    source  => "${factorio_home}/factorio/data/map-gen-settings.example.json",
  }
  file { "${factorio_home}/factorio/data/map-settings.${world_name}.json":
    ensure  => file,
    owner   => 'factorio',
    group   => 'factorio',
    mode    => '0644',
    replace => 'no',
    source  => "${factorio_home}/factorio/data/map-settings.example.json",
  }
  file { "${factorio_home}/factorio/data/server-settings.${world_name}.json":
    ensure  => file,
    owner   => 'factorio',
    group   => 'factorio',
    mode    => '0644',
    replace => 'no',
    source  => "${factorio_home}/factorio/data/server-settings.example.json",
  }
  file { '/etc/systemd/system/factorio@.service':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('factorio/factorio@.service.erb')
  }
  exec { 'create_server':
    command => "${factorio_home}/factorio/bin/x64/factorio --create ${factorio_home}/factorio/saves/${world_name}.zip --map-gen-settings ${factorio_home}/factorio/data/map-gen-settings.${world_name}.json --map-settings ${factorio_home}/factorio/data/map-settings.${world_name}.json",
    unless  => "test -f ${factorio_home}/factorio/saves/${world_name}.zip",
    notify  => Exec['factorio_chown'],
  }
  exec { 'reload_systemd':
    command     => 'systemctl daemon-reload',
    refreshonly => true,
    subscribe   => File['/etc/systemd/system/factorio@.service'],
  }
}
