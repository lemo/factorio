class factorio::service {
    service { 'factorio_service':
        name    => 'factorio',
        enable  => true,
        ensure  => true,
        }
}