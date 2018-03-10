#!/bin/bash
yum -y install https://yum.puppet.com/puppet5/puppet5-release-el-7.noarch.rpm
yum -y install puppetserver
# Installing the puppetserver will install the puppet-agent
#yum -y install puppet-agent

# Enable saltminion to target puppet master
echo "
[main]
certname = puppetmaster5.localdomain.com
server = puppetmaster5.localdomain.com" >>  /etc/puppetlabs/puppet/puppet.conf

# Change memory allocation to the master
sed -i 's/-Xms2g/-Xms512m/g' /etc/sysconfig/puppetserver
sed -i 's/-Xmx2g/-Xmx512m/g' /etc/sysconfig/puppetserver

# Start the puppet master
systemctl start puppetserver.service
systemctl enable puppetserver.service

echo "#####################################"
echo "Creating barebone puppet environments"
echo "#####################################"

# Making barebone puppet environments
mkdir /etc/puppetlabs/code/environments/production/modules/test
mkdir /etc/puppetlabs/code/environments/production/modules/test/manifests

echo "node /pup/ {
  class { 'test::test': }
}" > /etc/puppetlabs/code/environments/production/manifests/site.pp

echo "class test::test () {
  file { \"/tmp/test.txt\":
    ensure => file,
    owner  => root,
    group  => root,
    mode   => \"644\",
  }
}" > /etc/puppetlabs/code/environments/production/modules/test/manifests/test.pp

# Run a local puppet sync
/opt/puppetlabs/bin/puppet agent -o -v --no-daemonize

# Sign cert if needed
# puppet cert sign packer4.localdomain.com

echo "##################################"
echo "Installing Puppet DB (and Postgres)"
echo "##################################"
yum -y install puppetdb puppetdb-terminus
yum -y install puppetdb-termini

# Install the repository RPM:
yum -y install https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/pgdg-redhat10-10-1.noarch.rpm
# Install the client packages:
yum -y install postgresql10
# Optionally install the server packages:
yum -y install postgresql10-server postgresql10-contrib

# initialize the database and enable automatic start:
/usr/pgsql-10/bin/postgresql-10-setup initdb
systemctl enable postgresql-10.service
systemctl start postgresql-10.service

# Create user
#   [root@packer1 conf.d]# su - postgres
#   -bash-4.2$ createuser -DRSP puppetdb
#   Enter password for new role:
#   Enter it again:
su - postgres -c  "psql -c \"CREATE USER puppetdb WITH PASSWORD 'password';\""

# Create database
#  -bash-4.2$ createdb -E UTF8 -O puppetdb puppetdb
#  -bash-4.2$ logout
su - postgres -c  "createdb -E UTF8 -O puppetdb puppetdb"

# Install extepdnings
#  [root@packer1 conf.d]# su - postgres
#  Last login: Sat Dec 30 03:49:54 UTC 2017 on pts/0
#  -bash-4.2$ psql puppetdb -c 'create extension pg_trgm'
#  CREATE EXTENSION
#  -bash-4.2$ logout
#  [root@packer1 conf.d]#
su - postgres -c "psql puppetdb -c 'create extension pg_trgm'"

# Getting pg_hba.conf setup
cp -v /var/lib/pgsql/10/data/pg_hba.conf /var/lib/pgsql/10/data/pg_hba.conf.orginal

echo "# TYPE  DATABASE   USER   CIDR-ADDRESS  METHOD
local   all        all                  peer
host    all        all    127.0.0.1/32  md5
host    all        all    ::1/128       md5
" > /var/lib/pgsql/10/data/pg_hba.conf

# Resteart Postgres for pg_hba.conf change
systemctl  restart postgresql-10.service

# To test login, as postgres
# $ psql -h localhost puppetdb puppetdb

# Setting up puppetdb so it know where to look for postgres
cp -v /etc/puppetlabs/puppetdb/conf.d/database.ini  /etc/puppetlabs/puppetdb/conf.d/database.ini.org
# Setup database.ini
echo "[database]
#classname = org.postgresql.Driver
#subprotocol = postgresql

# The database address, i.e. //HOST:PORT/DATABASE_NAME
subname = //localhost:5432/puppetdb

# Connect as a specific user
username = puppetdb

# Use a specific password
password = password

# How often (in minutes) to compact the database
# gc-interval = 60

# Number of seconds before any SQL query is considered 'slow'; offending
# queries will not be interrupted, but will be logged at the WARN log level.
log-slow-statements = 10" > /etc/puppetlabs/puppetdb/conf.d/database.ini

# Enable puppet master to send reports to puppetdb
echo "storeconfigs = true" >> /etc/puppetlabs/puppet/puppet.conf
echo "storeconfigs_backend = puppetdb" >> /etc/puppetlabs/puppet/puppet.conf
echo "reports = store,puppetdb"   >> /etc/puppetlabs/puppet/puppet.conf

# Tell PuppetMaster how to connect to PuppetDB
echo "[main]
server_urls = https://puppetmaster5.localdomain.com:8081" > /etc/puppetlabs/puppet/puppetdb.conf

#
echo "---
master:
  facts:
    terminus: puppetdb
    cache: yaml" > /etc/puppetlabs/puppet/routes.yaml

# Starting puppetdb
systemctl stop puppetdb.service
systemctl start puppetdb.service
systemctl status puppetdb.service
systemctl enable puppetdb.service

echo "#########################"
echo "Restarting all services"
echo "#########################"
systemctl stop puppetserver.service
systemctl stop puppetdb.service
systemctl stop postgresql-10.service

systemctl start postgresql-10.service
systemctl start puppetdb.service
systemctl start puppetserver.service

# Run another puppet sync to get some data into puppetdb
/opt/puppetlabs/bin/puppet agent -o -v --no-daemonize

echo "#########################"
echo "Installing PuppetBoard"
echo "#########################"
# PuppetBoard
yum -y install epel-release
yum -y install python2-pip httpd mod_wsgi
pip install puppetboard

mkdir -p /var/www/html/puppetboard
cp -v /usr/lib/python2.7/site-packages/puppetboard/default_settings.py /var/www/html/puppetboard/

touch /var/www/html/puppetboard/settings.py

echo "from __future__ import absolute_import
import os

# Needed if a settings.py file exists
os.environ['PUPPETBOARD_SETTINGS'] = '/var/www/html/puppetboard/settings.py'
from puppetboard.app import app as application" > /var/www/html/puppetboard/wsgi.py


echo "<VirtualHost *:80>
    ServerName puppetmaster5.localdomain.com
    WSGIDaemonProcess puppetboard user=apache group=apache threads=5
    WSGIScriptAlias / /var/www/html/puppetboard/wsgi.py
    ErrorLog logs/puppetboard-error_log
    CustomLog logs/puppetboard-access_log combined

    Alias /static /usr/lib/python2.7/site-packages/puppetboard/static
    <Directory /usr/lib/python2.7/site-packages/puppetboard/static>
        Satisfy Any
        Allow from all
    </Directory>

    <Directory /usr/lib/python2.7/site-packages/puppetboard>
        WSGIProcessGroup puppetboard
        WSGIApplicationGroup %{GLOBAL}
        Require all granted
    </Directory>
</VirtualHost>" > /etc/httpd/conf.d/puppetboard.conf

# Starting the service
systemctl stop httpd.service
systemctl status httpd.service
systemctl start httpd.service
systemctl enable httpd.service

echo "#########################"
echo "Disable SE Linux"
echo "#########################"
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g'  /etc/sysconfig/selinux
