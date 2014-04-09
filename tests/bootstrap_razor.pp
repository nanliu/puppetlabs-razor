rz_broker { 'puppet10':
  ensure        => present,
  broker_type   => 'puppet',
  configuration => {
    'server'  => 'puppet.example.org'
  }
}

rz_repo { 'repo10':
  ensure => present,
  url    => 'http://someserver/somepath'
}

rz_policy { 'Policy_10':
  ensure        => present,
  enabled       => true,
  repo          => 'repo10',
  installer     => 'vmware_esxi',
  broker        => 'puppet10',
  hostname      => 'FV7QQV1.aidev.com',
  root_password => 'pass',
  max_count     => 1,
  rule_number   => 10,
#  tags          => [],
  tags          => [
         {
            "name" => "Tag_10",
            "rule" =>
               [
                  "=",
                  [
                     "fact",
                     "serialnumber"
                  ],
                  "FV7QQV1"
               ]
         }
  ],
}

#
# this is failing for some reason :(
#rz_repo { 'repo2':
#  ensure  => present,
#  iso_url => '/tmp/foo.iso'
#}
