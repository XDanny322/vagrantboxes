#!/bin/bash
#
# provision.sh for kafka
########################################################################
# Install needed tools
yum -y install epel-release
yum -y install wget mlocate vim net-tools telnet python2-pip

# See
# https://docs.confluent.io/current/installation/installing_cp.html#rpm-packages-via-yum
sudo yum install java

rpm --import https://packages.confluent.io/rpm/4.0/archive.key

echo '[Confluent.dist]
name=Confluent repository (dist)
baseurl=https://packages.confluent.io/rpm/4.0/7
gpgcheck=1
gpgkey=https://packages.confluent.io/rpm/4.0/archive.key
enabled=1

[Confluent]
name=Confluent repository
baseurl=https://packages.confluent.io/rpm/4.0
gpgcheck=1
gpgkey=https://packages.confluent.io/rpm/4.0/archive.key
enabled=1' > /etc/yum.repos.d/confluent.repo

yum clean all

# Confluent Enterprise:
# yum install confluent-platform-2.11

# Confluent Open Source:
yum -y install confluent-platform-oss-2.11
