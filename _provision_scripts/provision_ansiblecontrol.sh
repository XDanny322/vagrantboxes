#!/bin/bash
# This is how you can install ansible via yum, using epel-releases
#   yum -y install ansible

# This is needed for compiling Ansible when installing via pip
# sudo yum -y install gcc
# sudo yum -y install sshpass # This is needed for Ansible to use --ask-pass option
# sudo pip install virtualenv
# virtualenv venv
# source /home/vagrant/venv/bin/activate
# pip install -U pip setuptools # In case you need to update pip:
# pip install -r /vagrant/requirements.txt # The requirements.txt came from rsync via vagrant
#   Mon Jul 02 00:38:26 ~/vagrant/ansible(master) > cat requirements.txt
#   ansible==2.4.3.0
#   asn1crypto==0.24.0
#   bcrypt==3.1.4
#   cffi==1.11.5
#   cryptography==2.1.4
#   enum34==1.1.6
#   idna==2.6
#   ipaddress==1.0.19
#   Jinja2==2.10
#   MarkupSafe==1.0
#   paramiko==2.4.0
#   pyasn1==0.4.2
#   pycparser==2.18
#   PyNaCl==1.2.1
#   PyYAML==3.12
#   pywinrm==0.2.2

cd /vagrant/ansible_rpms/
sudo yum -y install ansible-2.5.5-1.el7.noarch.rpm
