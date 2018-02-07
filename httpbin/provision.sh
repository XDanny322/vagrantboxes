#!/bin/bash
#
# provision.sh for httpbin
########################################################################
# Install needed tools
yum -y install wget mlocate vim net-tools telnet

yum -y install epel-release
yum -y install python2-pip gcc
# pip install virtualenv
pip install httpbin==0.5.0
gunicorn -b 0.0.0.0:8000 httpbin:app &