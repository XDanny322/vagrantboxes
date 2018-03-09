#!/bin/bash
#
# provision for ansible
########################################################################
# Install needed tools
yum -y install epel-release
yum -y install wget mlocate vim net-tools telnet git

# This is how you can install ansible via yum, using epel-releases
# yum -y install ansible

yum -y install python2-pip
pip install virtualenv
su - vagrant
cd
virtualenv venv
source /home/vagrant/venv/bin/activate

# The requirements.txt came from rsync via vagrant
pip install /vagrant/requirements.txt

# Ansible should now be installed.

# You should now able to use stuff from /vagrant to use ansible
