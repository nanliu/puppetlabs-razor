class { tftp:
  username => 'root',
}

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

exec { 'razor_database_initialization':
  command     => 'jruby bin/razor-admin -e production migrate-database',
  path        => "/opt/razor-torquebox/jruby/bin:${path}",
  refreshonly => true,
  require     => Class['razor'],
  subscribe   => Postgresql::Server::Db['razor'],
}

$razor_pxe = inline_template('
subnet <%=@network_eth1%> netmask <%=@netmask_eth1%> {
  range 192.168.61.200 192.168.61.250;
  option broadcast-address 192.168.61.255;
  option subnet-mask 255.255.255.0;
  option domain-name-servers 192.168.61.3;
  option domain-name localdomain;
  option routers 192.168.61.3;
  option tftp-server-name "192.168.1.3";
  if exists user-class and option user-class = "iPXE" {
    filename "bootstrap.ipxe";
  } else {
    filename "undionly.kpxe";
  }
  next-server <%=@ipaddress_eth1%>;
}
')

class { 'dhcp':
  dnsdomain     => [
    '.razor.lan',
    '61.168.192.in-addr.arpa',
  ],
  nameservers   => ['192.168.61.1'],
  ntpservers    => ['us.pool.ntp.org'],
  interfaces    => ['eth1'],
  dhcp_conf_pxe => $razor_pxe,
}

staging::deploy { 'razor-microkernel.tar':
  source  => 'http://links.puppetlabs.com/razor-microkernel-latest.tar',
  target  => '/var/lib/razor/repo-store/',
  creates => '/var/lib/razor/repo-store/microkernel',
  require => Class['razor'],
}

# TODO:
# /opt/razor/config.yaml
