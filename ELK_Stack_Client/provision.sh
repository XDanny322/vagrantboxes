#!/bin/bash
#
# provision.sh for ELK Stack Client
########################################################################
myhostname=elkstackclient
elkserver=192.168.56.110

# Install needed tools
yum -y install wget mlocate vim net-tools telnet

# Make a directory to work in
mkdir /tmp/installs
cd /tmp/installs

###############################################################################
# Downloading FileBeat
#  Go here to find it https://www.elastic.co/downloads/beats/filebeat
wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.1.1-x86_64.rpm
rpm -ivh filebeat-6.1.1-x86_64.rpm

# Change filebeat from monitoring all /var/log/*.log to only /var/log/message.log for testing
sed -i "s/*.log/messages\n  document_type: syslog/g" /etc/filebeat/filebeat.yml

# Changing tags. Tags are meta data added per box
sed -i 's/#tags:/tags:/g' /etc/filebeat/filebeat.yml
sed -i 's/service-X/dlaitestserver/g' /etc/filebeat/filebeat.yml
sed -i 's/web-tier/tesbox/g' /etc/filebeat/filebeat.yml

# Adding custom fields
sed -i 's/#fields:/fields:/g' /etc/filebeat/filebeat.yml
sed -i 's/#  env: staging/  dlai_environment: production/g' /etc/filebeat/filebeat.yml

# Disable ElasticSearch output, since we will be sending to Logstash
sed -i 's/output.elasticsearch:/#output.elasticsearch:/g' /etc/filebeat/filebeat.yml
sed -i "s/hosts: \[\"localhost:9200\"\]/#hosts: \[\"localhost:9200\"\]/g" /etc/filebeat/filebeat.yml

# Enable logstash
sed -i 's/#output.logstash:/output.logstash:/g' /etc/filebeat/filebeat.yml
sed -i "s/#hosts: \[\"localhost:5044\"\]/hosts: \[\"$elkserver:5044\"\]/g" /etc/filebeat/filebeat.yml


# Do i need to enable some template?

# Start the service
systemctl daemon-reload
systemctl enable filebeat

systemctl status filebeat
systemctl start filebeat
systemctl status filebeat

