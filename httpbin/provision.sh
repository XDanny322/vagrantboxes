#!/bin/bash
#
# provision.sh for httpbin
#  https://httpbin.org
########################################################################
# Install needed tools
yum -y install epel-release
yum -y install wget mlocate vim net-tools telnet python2-pip

yum -y install epel-release
yum -y install python2-pip gcc
# pip install virtualenv
pip install httpbin==0.5.0
pip install gunicorn
gunicorn -b 0.0.0.0:8000 httpbin:app &