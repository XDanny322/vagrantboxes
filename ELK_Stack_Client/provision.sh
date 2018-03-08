#!/bin/bash
#
# provision.sh for ELK Stack Client
########################################################################
# Install needed tools
yum -y install epel-release
yum -y install wget mlocate vim net-tools telnet python2-pip


echo '[elasticsearch-6.x]
name=Elasticsearch repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md' > /etc/yum.repos.d/elasticsearch.repo
yum clean all

###############################################################################
# Downloading FileBeat
# Go here to find it https://www.elastic.co/downloads/beats/filebeat
#  wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.1.1-x86_64.rpm
#  rpm -ivh filebeat-6.1.1-x86_64.rpm
yum -y install filebeat

# Make a backup of the config file
cp -v /etc/filebeat/filebeat.yml /etc/filebeat/filebeat.yml.orginal

echo 'filebeat.prospectors:
- type: log
  enabled: true
  paths:
    - /var/log/messages
  document_type: syslog
filebeat.config.modules:
  path: ${path.config}/modules.d/*.yml
  reload.enabled: false
setup.template.settings:
  index.number_of_shards: 3
tags: ["dlaitestserver", "tesbox"]
fields:
  dlai_environment: production
setup.kibana:
output.logstash:
  hosts: ["192.168.56.110:5043"]' > /etc/filebeat/filebeat.yml

# Tell filebeat to load an index into elastic search.  This means that we
# will be disabling filebeat from talking to LogStash, and talk to LogStash directly
#
#  [root@elkstackclient ~]# filebeat setup --template -E output.logstash.enabled=false -E 'output.elasticsearch.hosts=["192.168.56.110:9200"]'
#  Loaded index template
#  [root@elkstackclient ~]#
/bin/filebeat setup --template -E output.logstash.enabled=false -E 'output.elasticsearch.hosts=["192.168.56.110:9200"]'

# Delete everything for EletricSearch just incase there are data in there.
curl -XDELETE 'http://192.168.56.110:9200/filebeat-*'

# Start the service
systemctl daemon-reload
systemctl enable filebeat.service
systemctl status filebeat.service
systemctl start filebeat.service
systemctl status filebeat.service
