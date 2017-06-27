class factorio::user {
    user { 'factorio':
        comment => '',
        home => '/home/factorio',
        ensure => present,
    }
    file { '/home/factorio':
        ensure  => 'directory',
        owner   => 'factorio',
        group   => 'factorio',
        }
}