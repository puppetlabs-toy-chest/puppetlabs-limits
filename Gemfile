source :rubygems

gem 'puppetlabs_spec_helper'
gem 'puppet-lint'


if ENV.key?('PUPPET_VERSION')
   puppetversion = "= #{ENV['PUPPET_VERSION']}"
else
   puppetversion = ['>= 2.7']
end

gem 'puppet', puppetversion
