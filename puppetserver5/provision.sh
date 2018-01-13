#!/bin/bash
#
# provision.sh for puppetmaster5
########################################################################
# Install needed tools
yum -y install wget mlocate vim net-tools telnet

yum -y install https://yum.puppet.com/puppet5/puppet5-release-el-7.noarch.rpm
yum -y install puppetserver
yum -y install puppet-agent

# Enable saltminion to target puppet master
echo "
[main]
certname = puppetmaster5.localdomain.com
server = puppetmaster5.localdomain.com
" >>  /etc/puppetlabs/puppet/puppet.conf

# Change memory allocation to the master
sed -i 's/-Xms2g/-Xms512m/g' /etc/sysconfig/puppetserver
sed -i 's/-Xmx2g/-Xmx512m/g' /etc/sysconfig/puppetserver

# Start the puppet master
systemctl start puppetserver.service
systemctl enable puppetserver.service

# Disable IPtables just incase
systemctl disable iptables.service
systemctl disable firewalld.service

# Making barebone puppet environments
mkdir /etc/puppetlabs/code/environments/production/modules/test
mkdir /etc/puppetlabs/code/environments/production/modules/test/manifests

echo "node /pup/ {
  class { 'test::test': }
}" > /etc/puppetlabs/code/environments/production/manifests/site.pp

echo "class test::test () {
  file { \"/tmp/test.txt\":
    ensure => file,
    owner  => root,
    group  => root,
    mode   => \"644\",
  }
}" > /etc/puppetlabs/code/environments/production/modules/test/manifests/test.pp

# Run a local puppet sync
/opt/puppetlabs/bin/puppet agent -o -v --no-daemonize

# Sign cert if needed
# puppet cert sign packer4.localdomain.com