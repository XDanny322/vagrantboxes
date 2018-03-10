#!/bin/bash
#
# provision for ansible
########################################################################
# Install needed tools
sudo yum -y install epel-release
sudo yum -y install wget mlocate vim net-tools telnet git

# This is how you can install ansible via yum, using epel-releases
# yum -y install ansible

sudo yum -y install python2-pip

# This is needed for compiling ansible when installing via pip
sudo yum -y install gcc

# This is needed for Ansible to use --ask-pass option
sudo yum -y install sshpass

sudo pip install virtualenv

virtualenv venv

source /home/vagrant/venv/bin/activate

# The requirements.txt came from rsync via vagrant
pip install -r /vagrant/requirements.txt

# Ansible should now be installed.

# You should now able to use stuff from /vagrant to use ansible
