#!/bin/bash
set -x

###############################################################################
# pycharm
#
pip install virtualenv
yum -y groupinstall "X Window System"
yum -y install dejavu-lgc-sans-fonts
yum -y install xclock

# Setting up pycharm, as vagrant
su - vagrant
cd /home/vagrant/
wget https://download.jetbrains.com/python/pycharm-community-2017.3.4.tar.gz
gunzip /home/vagrant/pycharm-community-2017.3.4.tar.gz
tar -xvf /home/vagrant/pycharm-community-2017.3.4.tar
###############################################################################

###############################################################################
# ruby 2.4.2 (CentOS7 Default comes with Ruby2.0)
#
# See https://tecadmin.net/install-ruby-latest-stable-centos/#
# yum install gcc-c++ patch readline readline-devel zlib zlib-devel \
#    libyaml-devel libffi-devel openssl-devel make \
#    bzip2 autoconf automake libtool bison iconv-devel sqlite-devel

# curl -sSL https://rvm.io/mpapis.asc | gpg --import -
# curl -L get.rvm.io | bash -s stable
# rvm install 2.4.2
# rvm use 2.4.2 --default
# gem install jekyll bundler minima
# bundle exec jekyll serve --host 0.0.0.0
###############################################################################

###############################################################################
# aws cli
su - vagrant
virtualenv venv_awscli
source venv_awscli/bin/activate
pip install awscli

