#!/bin/bash
########################################################################
# Install needed tools Default tools
sudo yum -y install epel-release
sudo yum -y install wget mlocate vim net-tools telnet git python2-pip
# Enable remote ssh
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo systemctl restart sshd.service
# Disable Firewall just incase
systemctl disable iptables.service
systemctl disable firewalld.service
########################################################################
