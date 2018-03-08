#!/bin/bash
#
# provision for my personal centos7 dev box
########################################################################
# Install needed tools
yum -y install epel-release
yum -y install wget mlocate vim net-tools telnet git python2-pip

# Install VENV
pip install virtualenv

# Enable SSH for my dev box
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g'  /etc/ssh/sshd_config
service sshd restart

# Install X and Char encoding.
yum -y groupinstall "X Window System"
yum -y install dejavu-lgc-sans-fonts

# Tool to test that X works
yum -y install xclock

# Setting up pycharm, as vagrant
su - vagrant
cd /home/vagrant/
wget https://download.jetbrains.com/python/pycharm-community-2017.3.4.tar.gz
gunzip /home/vagrant/pycharm-community-2017.3.4.tar.gz
tar -xvf /home/vagrant/pycharm-community-2017.3.4.tar
