#!/bin/bash
#
# provision.sh for saltclient
########################################################################
# Install needed tools
yum -y install epel-release
yum -y install wget mlocate vim net-tools telnet python2-pip

yum -y install https://repo.saltstack.com/yum/redhat/salt-repo-latest-2.el7.noarch.rpm
yum -y install salt-minion

# Placing specific version of salt repo
# echo "[salt-2017.7.2]
# name=SaltStack 2017.7.2
# baseurl=https://repo.saltstack.com/yum/redhat/7/x86_64/archive/2017.7.2/
# failovermethod=priority
# enabled=1
# gpgcheck=0" > /etc/yum.repos.d/salt-2017.7.2.repo
# yum -y install salt-minion-2017.7.2-1.el7

# Point the salt minion to the master
echo "master: 192.168.56.113" > /etc/salt/minion

# Start the salt minion
systemctl start salt-minion.service
systemctl enable salt-minion.service

# Disable IPtables just incase
systemctl disable iptables.service
systemctl disable firewalld.service
