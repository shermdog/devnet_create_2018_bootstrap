$bootstrap_packages = ['gcc', 'zlib-devel', 'patch']

package { $bootstrap_packages:
  ensure => 'present',
}

package { 'net-netconf':
  ensure   => 'present',
  name     => 'puppet-resource_api',
  provider => puppet_gem,
  source   => 'net-netconf-0.5.0.pre.dev.20170710.1.gem',
  require => Package['gcc', 'zlib-devel'],
}

service { 'firewalld.service':
  ensure => 'stopped',
  enable => 'false',
}

file { '/root/.bash_profile':
  ensure => file,
  owner  => 'root',
  group  => 'root',
  mode   => '0644',
  content => file(inline_template("<%= File.expand_path(File.dirname(__FILE__)) + '/bash_profile' %>")),
}