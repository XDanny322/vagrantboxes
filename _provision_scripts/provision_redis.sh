#!/bin/bash
########################################################################
#
# ReJson For CentOS:
#   See: https://gist.github.com/lmj0011/820eea392f6f43c755fadc2ba56b69e9#gistcomment-2863019
#
# UPDATING AND INSTALLING PACKAGES
# yum update -y
# yum install epel-release yum-utils -y
# yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
# yum-config-manager --enable remi
# yum install redis git -y
# SETTING VARIABLES
# REJSON_MODULES=$(rpm -ql redis | grep modules)  # default: /usr/lib64/redis/modules
# REDIS_CONF=$(rpm -ql redis | grep "redis.conf$")  # default: /etc/redis.conf
# HOST_IP=$(ip addr show eth0 | grep -Po "inet \K[\d.]+")
# INSTALLING REJSON MODULE
# cd /usr/src
# git clone https://github.com/RedisLabsModules/rejson.git
# cd rejson/
# make
# cp src/rejson.so ${REJSON_MODULES}
# chown redis:redis ${REJSON_MODULES}/rejson.so
# chmod 750 ${REJSON_MODULES}/rejson.so
# CHANGING CONFIGURATION AND STARTING REDIS
# sed -i "/MODULES/a loadmodule ${REJSON_MODULES}/rejson.so" ${REDIS_CONF}
# sed -i "s/bind 127.0.0.1/bind ${HOST_IP}/g" ${REDIS_CONF}  # remove this line if you dont want redis server to be accessible from outside
# systemctl start redis
# systemctl enable redis

sudo yum install epel-release yum-utils -y
sudo yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
sudo yum install redis -y

sudo systemctl start redis
sudo systemctl enable redis
sudo systemctl status redis

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf

sudo systemctl stop redis
sleep 1
sudo systemctl start redis
sleep 1
sudo systemctl status redis
sleep 1

netstat -anop | grep  6379

redis-cli -h 127.0.0.1  ping
sleep 1

# Backup here: /var/lib/redis/dump.rdb
########################################################################
