#!/bin/bash
#
# provision.sh for saltmaster
########################################################################
# Install needed tools
yum -y install wget mlocate vim net-tools telnet

yum -y install https://repo.saltstack.com/yum/redhat/salt-repo-latest-2.el7.noarch.rpm
yum -y install salt-master

# Enable saltmaster to list on all interfacts
sed -i 's/#interface: 0.0.0.0/interface: 0.0.0.0/g' /etc/salt/master

# Start the salt master
systemctl start salt-master.service
systemctl enable salt-master.service

# Disable IPtables just incase
systemctl disable iptables.service
systemctl disable firewalld.service
