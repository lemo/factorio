class factorio::install (
    $world_name = hiera(factorio::world_name, world1)
    ) {
    $required_packages = [ 'wget', 'unzip' ]
    package { $required_packages:
        ensure => installed,
        
    }
    exec { 'download':
        command => '/bin/wget -O /home/factorio/server.tar.gz https://factorio.com/get-download/latest/headless/linux64',
        unless  => '/bin/test -f /home/factorio/server.tar.gz',
        }
    exec { 'extract':
        command => '/bin/tar xvf server.tar.gz',
        cwd     => '/home/factorio',
        unless  => '/bin/test -d /home/factorio/factorio',
        }
    file { '/home/factorio/ensure_permissions.py':
	ensure   => file,
	owner    => 'factorio',
        group 	 => 'factorio',
	mode     => '0644',
	source	 => 'puppet:///modules/factorio/ensure_permissions.py'
	}
    exec { 'factorio_chown':
        command  => '/bin/chown -R factorio:factorio /home/factorio',
        unless   => '/bin/python /home/factorio/ensure_permissions.py',
        }
    file { '/etc/systemd/system/factorio.service':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content  => template('factorio/factorio.service.erb')
        }
    exec { 'create_server':
        command => "/home/factorio/factorio/bin/x64/factorio --create /home/factorio/factorio/saves/$world_name.zip",
        unless  => "/bin/test -f /home/factorio/factorio/saves/$world_name.zip",
        }
    exec { 'reload_systemd':
        command     => '/bin/systemctl daemon-reload',
        refreshonly => true,
        subscribe   => File['/etc/systemd/system/factorio.service'],
	notify      => Service['factorio_service']
        }
}
