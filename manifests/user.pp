class factorio::user {
    user { 'factorio':
        ensure => present,
        comment => '',
        home => '/home/factorio',
    }
    file { '/home/factorio':
        ensure  => 'directory',
        owner   => 'factorio',
        group   => 'factorio',
        }
}