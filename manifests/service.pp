class factorio::service {
  $world_name = $factorio::world_name
  service { "factorio@${world_name}":
    ensure => true,
    enable => false,
  }
}
