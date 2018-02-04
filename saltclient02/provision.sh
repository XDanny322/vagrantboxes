#!/bin/bash
#
# provision.sh for saltclient
########################################################################
# Install needed tools
yum -y install wget mlocate vim net-tools telnet

yum -y install https://repo.saltstack.com/yum/redhat/salt-repo-latest-2.el7.noarch.rpm
yum -y install salt-minion-2017.7.2-1.el7

# Point the salt minion to the master
echo "master: 192.168.56.113" > /etc/salt/minion

# Start the salt minion
systemctl start salt-minion.service
systemctl enable salt-minion.service

# Disable IPtables just incase
systemctl disable iptables.service
systemctl disable firewalld.service
