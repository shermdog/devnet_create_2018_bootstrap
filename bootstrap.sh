#!/bin/bash

# Set hostname to puppet to make lab easier
echo "Setting hostname..."
/usr/bin/sed -i 's/localhost.localdomain/puppet/g' /etc/hostname
/usr/bin/sed -i 's/localhost/puppet/g' /etc/hosts
/usr/bin/hostname -F /etc/hostname

echo "Downloading Puppet Enterprise..."
/usr/bin/curl -O https://s3.amazonaws.com/pe-builds/released/2017.3.5/puppet-enterprise-2017.3.5-el-7-x86_64.tar.gz

echo "Extracting Puppet Enterprise..."
/usr/bin/tar -xvf puppet-enterprise-2017.3.5-el-7-x86_64.tar.gz

echo "Installing Puppet Enterprise..."
./puppet-enterprise-2017.3.5-el-7-x86_64/puppet-enterprise-installer -c demo-pe.conf

# Puppet Enterprise installation is completed by subsequent agent runs
echo "Running puppet..."
/usr/local/bin/puppet agent -t
echo "Running puppet again..."
/usr/local/bin/puppet agent -t

echo "Patching PE..."
# These are patches from Puppet 5.3.6 which will be released just after DevNet Create 2018
/usr/bin/patch -b -d/opt/puppetlabs/puppet/lib/ruby/vendor_ruby/puppet -p3 <0001-PUP-8041-puppet-device-resource.patch
/usr/bin/patch -b -d/opt/puppetlabs/puppet/lib/ruby/vendor_ruby/puppet -p3 <0001-PUP-8364-apply-like-functionality-for-device.patch
/usr/bin/patch -b -d/opt/puppetlabs/puppet/lib/ruby/vendor_ruby/puppet -p3 <0001-PUP-8562-Improve-lookup-performance.patch

echo "Use puppet apply for further bootstrap..."
/usr/local/bin/puppet apply devnet.pp

echo "Install IETF Demo Puppet Module..."
/usr/local/bin/puppet module install shermdog-yang_ietf-0.0.1.tar.gz --ignore-dependencies

echo "Enable rich_data for pcore support..."
/usr/local/bin/puppet config set rich_data true

echo "Restart puppetserver for rich_data..."
/usr/bin/systemctl restart pe-puppetserver

