# Examples for downloading/importing razor mk image:
rz_image { 'rz_mk_prod-image.0.9.0.4.iso':
  ensure  => present,
  type    => 'mk',
  source  => 'https://github.com/downloads/puppetlabs/Razor-Microkernel/rz_mk_prod-image.0.9.0.4.iso',
}

rz_image { 'VMware-VMvisor-Installer-5.0.0-469512.x86_64.iso':
  ensure => present,
  type   => 'esxi',
  source => '/mnt/nfs/VMware-VMvisor-Installer-5.0.0-469512.x86_64.iso',
}

rz_model { 'vmware':
  ensure    => present,
  image     => 'VMware-VMvisor-Installer-5.0.0-469512.x86_64.iso',
  metadata  => { 'domainname'      => 'dmz25.lab',
                 'hostname_prefix' => 'esx',
                 'root_password'   => 'password',
                 'esx_license'     => 'AAAAA-BBBBB-CCCCC-DDDDD-EEEEE',
                 'nameserver'      => '192.168.232.1',
                 'gateway'         => '192.168.232.1',
                 'ntpserver'       => 'ntp.puppetlabs.lan',
                 'vcenter_name'    => 'vcsa.puppetlabs.lan',
                 'vcenter_datacenter_path' => 'dc1',
                 'ip_range_network' => '192.168.232',
                 'ip_range_start'   => '240',
                 'ip_range_end'     => '250',
                 'ip_range_subnet'  => '255.255.255.0',
  },
  template  => 'vmware_esxi_5',
}

rz_tag { 'vmware':
  tag_label   => 'vmware',
  tag_matcher => [
    { 'key'     => 'virtual',
      'compare' => 'equal',
      'value'   => 'vmware',
      'inverse' => false,
    } ],
}

rz_policy { 'vmware':
  ensure  => 'present',
  broker  => 'none',
  model   => 'vmware',
  enabled => 'true',
  tags    => ['vmware'],
  template => 'vmware_hypervisor',
  maximum => 10,
}
