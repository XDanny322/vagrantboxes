#!/bin/bash
#
# provision.sh for ELK Stack Server
########################################################################
# Install needed tools
yum -y install wget mlocate vim net-tools telnet

###############################################################################
# Downloading and install java
yum -y install java

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
# Downloading Elastic
# Go here to find it https://www.elastic.co/downloads/elasticsearch
#  wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.1.1.rpm
#  rpm -ivh elasticsearch-6.1.1.rpm
yum -y install elasticsearch

# Primary Elastic config file /etc/elasticsearch/elasticsearch.yml
sed -i 's/#cluster.name: my-application/cluster.name: dlai-monitoring-cluster/g' /etc/elasticsearch/elasticsearch.yml
# If needed change this as well, since it will tell elastic to listen on more then localhost
sed -i 's/#network.host: 192.168.0.1/network.host: 0.0.0.0/g' /etc/elasticsearch/elasticsearch.yml

# Start the service
systemctl daemon-reload
systemctl enable elasticsearch.service
systemctl status elasticsearch.service
systemctl start elasticsearch.service
systemctl status elasticsearch.service

# Test the service:
# sleep 15
# Im not sure why, but this always fails.
#  curl http://localhost:9200

###############################################################################
# Downloading LogStash
# Go here to find it https://www.elastic.co/downloads/logstash
#  wget https://artifacts.elastic.co/downloads/logstash/logstash-6.1.1.rpm
#  rpm -ivh logstash-6.1.1.rpm
yum -y install logstash

# You can test running Logstash manually by:
#  1) cd /usr/share/logstash/ ; bin/logstash -e 'input { stdin { } } output {  elasticsearch { hosts => ["localhost:9200"] }}'
#  2) Enter some stdin
#  3) Using Postman to check output
#    [root@localhost logstash]# curl http://localhost:9200/logstash-*/_search | python -mjson.tool

# Start the service
systemctl daemon-reload
systemctl enable logstash.service
systemctl status logstash.service
systemctl start logstash.service
systemctl status logstash.service

#Here is the grok setting when we are ready to enable:
  # echo 'input{
  #   beats{
  #     port => "5043"
  #   }
  # }
  # filter {
  #   if [type] == "syslog" {
  #     grok {
  #       match => { "message" => "%{SYSLOGTIMESTAMP:syslog_timestamp} %{SYSLOGHOST:syslog_hostname} %{DATA:syslog_program}(?:\[%{POSINT:syslog_pid}\])?: %{GREEDYDATA:syslog_message}" }
  #     }
  #     date{
  #       match => [ "syslog_timestamp", "MMM  d HH:mm:ss", "MMM dd HH:mm:ss" ]
  #     }
  #   }
  # }
  # output{
  #   elasticsearch {
  #     hosts => ["127.0.0.1:9200"]
  #     index => "%{[@metadata][beat]}-%{+YYYY.MM.dd}"
  #     document_type => "%{[@metadata][type]}"
  #   }
  # }' > /etc/logstash/conf.d/beats.conf

###############################################################################
# Downloading kibana
# Go here to find it https://www.elastic.co/downloads/kibana
#  wget https://artifacts.elastic.co/downloads/kibana/kibana-6.1.1-x86_64.rpm
#  rpm -ivh kibana-6.1.1-x86_64.rpm
yum -y install kibana

# Change listening interfact to all interfact
sed -i 's/#server.host: "localhost"/server.host: "0.0.0.0"/g' /etc/kibana/kibana.yml
# Change server name
sed -i "s/#server.name: \"your-hostname\"/server.name: \"elkstackserver\"/g" /etc/kibana/kibana.yml
# Enable default of 'localhost' for elasticsearch url.
sed -i 's/#elasticsearch.url/elasticsearch.url/g' /etc/kibana/kibana.yml
# Enable logging
sed -i "s/#logging.dest: stdout/logging.dest: \/tmp\/kibana.log/g" /etc/kibana/kibana.yml

# Start the service
systemctl daemon-reload
systemctl enable kibana
systemctl status kibana
systemctl start kibana
systemctl status kibana

# Test by point a brower to http://<IP>:5601/