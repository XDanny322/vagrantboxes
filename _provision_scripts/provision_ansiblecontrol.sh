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

# The requirements.txt came from rsync via vagrant
pip install -r /vagrant/requirements.txt

# Getting known hows for slave systems onto
#  See: https://askubuntu.com/questions/123072/ssh-automatically-accept-keys
#
# This has been turned off, since we asked ansbile to not check SSH Fingerprints
# in ansible.cfg
#  See: http://docs.ansible.com/ansible/latest/intro_configuration.html#host-key-checking
#
# hosts="127.0.0.1 192.168.56.126 192.168.56.127 192.168.56.128"
# for host in $hosts
# do
#     ssh-keyscan -H $host >> ~/.ssh/known_hosts
# done
