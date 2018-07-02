#!/bin/bash
# This is how you can install ansible via yum, using epel-releases
#   yum -y install ansible

# This is needed for compiling Ansible when installing via pip
sudo yum -y install gcc

# This is needed for Ansible to use --ask-pass option
sudo yum -y install sshpass

sudo pip install virtualenv
virtualenv venv
source /home/vagrant/venv/bin/activate

# In case you need to update pip:
#  pip install -U pip setuptools

# The requirements.txt came from rsync via vagrant
# pip install -r /vagrant/requirements.txt
