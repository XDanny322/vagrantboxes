#!/bin/bash
########################################################################
# https://docs.influxdata.com/influxdb/v1.7/introduction/installation/
# https://docs.influxdata.com/influxdb/v1.7/introduction/getting-started/
# https://docs.influxdata.com/influxdb/v1.7/guides/
# https://docs.influxdata.com/influxdb/v1.7/guides/writing_data/
# https://grafana.com/docs/installation/rpm/
# https://grafana.com/docs/guides/getting_started/

# Influx
cat <<EOF | sudo tee /etc/yum.repos.d/influxdb.repo
[influxdb]
name = InfluxDB Repository - RHEL \$releasever
baseurl = https://repos.influxdata.com/rhel/\$releasever/\$basearch/stable
enabled = 1
gpgcheck = 1
gpgkey = https://repos.influxdata.com/influxdb.key
EOF

sudo yum install influxdb -y
sudo systemctl start influxdb

sleep 5

# Influx Configure
curl -i -XPOST http://localhost:8086/query --data-urlencode "q=CREATE DATABASE mydb"
curl -i -XPOST 'http://localhost:8086/write?db=mydb' --data-binary 'cpu_load_short,host=server01,region=us-west value=0.64'
curl -i -XPOST 'http://localhost:8086/write?db=mydb' --data-binary 'cpu_load_short,host=server01,region=us-west value=0.67'
curl -i -XPOST 'http://localhost:8086/write?db=mydb' --data-binary 'cpu_load_short,host=server01,region=us-west value=0.61'

# Query:
# curl -G 'http://localhost:8086/query?pretty=true' --data-urlencode "db=mydb" --data-urlencode "q=SELECT \"value\" FROM \"cpu_load_short\" WHERE \"region\"='us-west'"curl -G 'http://localhost:8086/query?pretty=true' --data-urlencode "db=mydb" --data-urlencode "q=SELECT \"value\" FROM \"cpu_load_short\" WHERE \"region\"='us-west'"

# Grafana
cat <<EOF | sudo tee /etc/yum.repos.d/grafana.repo
[grafana]
name=grafana
baseurl=https://packages.grafana.com/oss/rpm
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://packages.grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
EOF

# Grafana Install
sudo yum install grafana -y
sudo systemctl daemon-reload
sudo systemctl start grafana-server
sudo systemctl status grafana-server

# Done
#  You can now hit http://192.168.56.144:3000 and login with admin/admin
#  Setup InfluxDB As a data source
#  Start building charts
