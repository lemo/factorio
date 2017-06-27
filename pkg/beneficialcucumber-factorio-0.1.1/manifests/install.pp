class factorio::install {
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
    exec { 'factorio_chown':
        command  => '/bin/chown -R factorio:factorio /home/factorio',
        unless   => '/bin/ls -ld /home/factorio/factorio | /bin/grep "factorio factorio"',
        }
    file { '/etc/systemd/system/factorio.service':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content  => template('factorio/factorio.service.erb')
        }
    exec { 'create_server':
        command => '/home/factorio/factorio/bin/x64/factorio --create /home/factorio/factorio/saves/world.zip',
        unless  => '/bin/test -f /home/factorio/factorio/saves/world.zip',
        }
    exec { 'reload_systemd':
        command => '/bin/systemctl daemon-reload',
        refreshonly => true,
        subscribe => File['/etc/systemd/system/factorio.service'],
        }
}