# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  config.vm.network 'private_network', :ip => '192.168.61.3'
  #config.vm.network 'vmnet2',

  config.vm.synced_folder './', '/etc/puppet/modules/razor'

  config.vm.define :razor do |m|
    m.vm.box = 'centos65'
    #m.vm.box_url = 'https://dl.dropboxusercontent.com/u/1075709/box/centos64.box'

    m.vm.hostname = 'razor'
    m.vm.provider :vmware_fusion do |v|
      v.vmx['displayName'] = 'razor'
      v.vmx['memsize'] = 1024
      v.vmx['numvcpus'] = 4
    end

    m.vm.provision :puppet do |puppet|
      puppet.manifests_path = 'tests'
      puppet.module_path    = 'spec/fixtures/modules/'
      puppet.manifest_file  = 'init.pp'
    end
  end
end
