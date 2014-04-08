include razor

class { 'postgresql::globals':
  manage_package_repo => true,
  version             => '9.2',
}->

class { 'postgresql::server':
  postgres_password => 'P@ssw0rd',
}

postgresql::server::db { 'razor':
  user     => 'razor',
  password => postgresql_password('razor', 'mypass'),
}
