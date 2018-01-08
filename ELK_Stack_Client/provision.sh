#!/bin/bash
#
# provision.sh for ELK Stack Client
########################################################################
# Install needed tools
yum -y install wget mlocate vim net-tools telnet


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
  enabled: false
  paths:
    - /var/log/messages
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

# Start the service
systemctl daemon-reload
systemctl enable filebeat
systemctl status filebeat
systemctl start filebeat
systemctl status filebeat

# Do i need to enable some template?



