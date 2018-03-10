#!/bin/bash

# Setting up pycharm
pip install virtualenv

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
