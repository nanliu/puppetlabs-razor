require 'rubygems'
require 'puppetlabs_spec_helper/rake_tasks'

# Customize lint option
task :lint do
  PuppetLint.configuration.send("disable_80chars")
  PuppetLint.configuration.send("disable_class_parameter_defaults")
  PuppetLint.configuration.ignore_paths = ["spec/**/*.pp", "pkg/**/*.pp"]
end

# Initialize vagrant instance for testing
desc 'Start vagrant test instance.'
task :vagrant do
  Rake::Task["spec_prep"].execute
  IO.popen('vagrant up --provider=vmware_fusion') do |io|
    io.each{ |line| print line }
  end
end

# Cleanup vagrant environment
desc 'Destroy vagrant test instance.'
task :vagrant_clean do
  `vagrant destroy -f`
  Rake::Task["spec_clean"].execute
end
