class factorio::service {
    service { 'factorio_service':
        ensure  => true,
        name    => 'factorio',
        enable  => true,
        }
}