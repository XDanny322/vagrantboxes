#!/bin/bash
#
# provision.sh for kafka
########################################################################
# Install needed tools
yum -y install epel-release
yum -y install wget mlocate vim net-tools telnet python2-pip

# See
# https://docs.confluent.io/current/installation/installing_cp.html#rpm-packages-via-yum
yum -y install java

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

###################################################
# Some files in kafka needs id, like 1, 2, 3, etc.
# The below -if- statement is to enforce those
#
if [[ `hostname -f` == "confluent-kafka01" ]]
then
  num="1"
elif  [[ `hostname -f` == "confluent-kafka02" ]]
then
  num="2"
elif [[ `hostname -f` == "confluent-kafka03" ]]
then
  num="3"
fi
echo $num


#
# Starting configuration
yes | cp /etc/kafka/zookeeper.properties /etc/kafka/zookeeper.properties.back

echo '# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# the directory where the snapshot is stored.
# dataDir=/var/lib/zookeeper
dataDir=/usr/ops/kafka/snapshots/
# the port at which the clients will connect
clientPort=2181
# disable the per-ip limit on the number of connections since this is a non-production config
maxClientCnxns=0

########## Edits added below
# Time unit in milliseconds used by ZooKeeper.
tickTime=2000

# Timeout ZooKeeper uses to limit the length of time ZooKeeper servers in quorum have to connect to leader. Measured in tickTime i,e 5*2000ms
initLimit=5

# The synch limit is the amount of time in ticks which is allowed for a follower to synch with leader.
syncLimit=2

# Severs that makeup ZooKeeper service. HostName:Port1:Port2 .
# List the hostnames of all the machines where ZooKeeper will be running.
# Port1 -> Node to node communication. Port2 -> Used to elect new leader.
server.1=192.168.56.122:2666:3666
server.2=192.168.56.123:2666:3666
server.3=192.168.56.124:2666:3666

# The directory where the snapshot is stored.

' > /etc/kafka/zookeeper.properties

# This houses snapshots and 'myid' file
sudo mkdir -p /usr/ops/kafka/snapshots
echo $num > /usr/ops/kafka/snapshots/myid

yes | cp -f /etc/kafka/server.properties /etc/kafka/server.properties.back
echo '# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# see kafka.server.KafkaConfig for additional details and defaults

############################# Server Basics #############################

# The id of the broker. This must be set to a unique integer for each broker.
broker.id=$num

############################# Socket Server Settings #############################

# The address the socket server listens on. It will get the value returned from
# java.net.InetAddress.getCanonicalHostName() if not configured.
#   FORMAT:
#     listeners = listener_name://host_name:port
#   EXAMPLE:
#     listeners = PLAINTEXT://your.host.name:9092
#listeners=PLAINTEXT://:9092

# Hostname and port the broker will advertise to producers and consumers. If not set,
# it uses the value for "listeners" if configured.  Otherwise, it will use the value
# returned from java.net.InetAddress.getCanonicalHostName().
#advertised.listeners=PLAINTEXT://your.host.name:9092

# Maps listener names to security protocols, the default is for them to be the same. See the config documentation for more details
#listener.security.protocol.map=PLAINTEXT:PLAINTEXT,SSL:SSL,SASL_PLAINTEXT:SASL_PLAINTEXT,SASL_SSL:SASL_SSL

# The number of threads that the server uses for receiving requests from the network and sending responses to the network
num.network.threads=3

# The number of threads that the server uses for processing requests, which may include disk I/O
num.io.threads=8

# The send buffer (SO_SNDBUF) used by the socket server
socket.send.buffer.bytes=102400

# The receive buffer (SO_RCVBUF) used by the socket server
socket.receive.buffer.bytes=102400

# The maximum size of a request that the socket server will accept (protection against OOM)
socket.request.max.bytes=104857600


############################# Log Basics #############################

# A comma seperated list of directories under which to store log files
log.dirs=/var/lib/kafka

# The default number of log partitions per topic. More partitions allow greater
# parallelism for consumption, but this will also result in more files across
# the brokers.
num.partitions=1

# The number of threads per data directory to be used for log recovery at startup and flushing at shutdown.
# This value is recommended to be increased for installations with data dirs located in RAID array.
num.recovery.threads.per.data.dir=1

############################# Internal Topic Settings  #############################
# The replication factor for the group metadata internal topics "__consumer_offsets" and "__transaction_state"
# For anything other than development testing, a value greater than 1 is recommended for to ensure availability such as 3.
offsets.topic.replication.factor=3
transaction.state.log.replication.factor=1
transaction.state.log.min.isr=1

############################# Log Flush Policy #############################

# Messages are immediately written to the filesystem but by default we only fsync() to sync
# the OS cache lazily. The following configurations control the flush of data to disk.
# There are a few important trade-offs here:
#    1. Durability: Unflushed data may be lost if you are not using replication.
#    2. Latency: Very large flush intervals may lead to latency spikes when the flush does occur as there will be a lot of data to flush.
#    3. Throughput: The flush is generally the most expensive operation, and a small flush interval may lead to exceessive seeks.
# The settings below allow one to configure the flush policy to flush data after a period of time or
# every N messages (or both). This can be done globally and overridden on a per-topic basis.

# The number of messages to accept before forcing a flush of data to disk
#log.flush.interval.messages=10000

# The maximum amount of time a message can sit in a log before we force a flush
#log.flush.interval.ms=1000

############################# Log Retention Policy #############################

# The following configurations control the disposal of log segments. The policy can
# be set to delete segments after a period of time, or after a given size has accumulated.
# A segment will be deleted whenever *either* of these criteria are met. Deletion always happens
# from the end of the log.

# The minimum age of a log file to be eligible for deletion due to age
log.retention.hours=168

# A size-based retention policy for logs. Segments are pruned from the log unless the remaining
# segments drop below log.retention.bytes. Functions independently of log.retention.hours.
#log.retention.bytes=1073741824

# The maximum size of a log segment file. When this size is reached a new log segment will be created.
log.segment.bytes=1073741824

# The interval at which log segments are checked to see if they can be deleted according
# to the retention policies
log.retention.check.interval.ms=300000

############################# Zookeeper #############################

# Zookeeper connection string (see zookeeper docs for details).
# This is a comma separated host:port pairs, each corresponding to a zk
# server. e.g. "127.0.0.1:3000,127.0.0.1:3001,127.0.0.1:3002".
# You can also append an optional chroot string to the urls to specify the
# root directory for all kafka znodes.
zookeeper.connect=192.168.56.122:2181,192.168.56.123:2181,192.168.56.124:2181


# Timeout in ms for connecting to zookeeper
zookeeper.connection.timeout.ms=6000

##################### Confluent Metrics Reporter #######################
# Confluent Control Center and Confluent Auto Data Balancer integration
#
# Uncomment the following lines to publish monitoring data for
# Confluent Control Center and Confluent Auto Data Balancer
# If you are using a dedicated metrics cluster, also adjust the settings
# to point to your metrics kakfa cluster.
#metric.reporters=io.confluent.metrics.reporter.ConfluentMetricsReporter
#confluent.metrics.reporter.bootstrap.servers=localhost:9092
#
# Uncomment the following line if the metrics cluster has a single broker
#confluent.metrics.reporter.topic.replicas=1

##################### Confluent Proactive Support ######################
# If set to true, and confluent-support-metrics package is installed
# then the feature to collect and report support metrics
# ("Metrics") is enabled.  If set to false, the feature is disabled.
#
confluent.support.metrics.enable=true

############################# Group Coordinator Settings #############################

# The following configuration specifies the time, in milliseconds, that the GroupCoordinator will delay the initial consumer rebalance.
# The rebalance will be further delayed by the value of group.initial.rebalance.delay.ms as new members join the group, up to a maximum of max.poll.interval.ms.
# The default value for this is 3 seconds.
# We override this to 0 here as it makes for a better out-of-the-box experience for development and testing.
# However, in production environments the default value of 3 seconds is more suitable as this will help to avoid unnecessary, and potentially expensive, rebalances during application startup.
group.initial.rebalance.delay.ms=0


# The customer ID under which support metrics will be collected and
# reported.
#
# When the customer ID is set to "anonymous" (the default), then only a
# reduced set of metrics is being collected and reported.
#
# Confluent customers
# -------------------
# If you are a Confluent customer, then you should replace the default
# value with your actual Confluent customer ID.  Doing so will ensure
# that additional support metrics will be collected and reported.
#
confluent.support.customer.id=anonymous

# Added the following properties. These properties
#  a) defines replication factor for each topic.
#  b) number of nodes to which message has to be written before sending ack to producer.
default.replication.factor=3
min.insync.replicas=2

' >  /etc/kafka/server.properties

# Auto start up
#  Sourced: https://github.com/thmshmm/confluent-systemd
echo '[Unit]
Description=Confluent ZooKeeper
After=network.target network-online.target remote-fs.target

[Service]
Type=forking
Environment="KAFKA_JMX_OPTS=-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=10020 -Dcom.sun.management.jmxremote.local.only=true -Dcom.sun.management.jmxremote.authenticate=false"
Environment="LOG_DIR=/var/log/zookeeper"
Environment="KAFKA_HEAP_OPTS= -Xmx4G -Xms2G"
# Uncomment the following line to enable authentication for the zookeeper
# Environment="KAFKA_OPTS=-Djava.security.auth.login.config=/etc/kafka/zookeeper_server_jaas.conf -Djava.security.krb5.conf=/etc/krb5.conf"
ExecStart=/usr/bin/zookeeper-server-start -daemon /etc/kafka/zookeeper.properties
ExecStop=/usr/bin/zookeeper-server-stop
SuccessExitStatus=143

[Install]
WantedBy=multi-user.target
' > /usr/lib/systemd/system/zookeeper.service

echo '[Unit]
Description=Confluent Kafka Broker
After=network.target network-online.target remote-fs.target zookeeper.service

[Service]
Type=forking
Environment="KAFKA_JMX_OPTS=-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=10030 -Dcom.sun.management.jmxremote.local.only=true -Dcom.sun.management.jmxremote.authenticate=false"
Environment="LOG_DIR=/var/log/kafka"
Environment="KAFKA_HEAP_OPTS= -Xmx4G -Xms2G"
# Uncomment the following line to enable authentication for the broker
# Environment="KAFKA_OPTS=-Djava.security.auth.login.config=/etc/kafka/kafka-jaas.conf -Djava.security.krb5.conf=/etc/krb5.conf"
ExecStart=/usr/bin/kafka-server-start -daemon /etc/kafka/server.properties
ExecStop=/usr/bin/kafka-server-stop
SuccessExitStatus=143

[Install]
WantedBy=multi-user.target
' > /usr/lib/systemd/system/kafka.service

systemctl enable kafka
systemctl enable zookeeper
systemctl daemon-reload

# systemctl start zookeeper
# systemctl start kafka
# systemctl stop zookeeper
# systemctl stop kafka

# How to test:
# confluent start schema-registry
# nohup zookeeper-server-start /etc/kafka/zookeeper.properties &
# nohup kafka-server-start /etc/kafka/server.properties &
# nohup schema-registry-start /etc/schema-registry/schema-registry.properties &
# >/dev/null 2>&1 </dev/null &

# How to start stop
#   [vagrant@centos7clean01 ~]$  confluent start schema-registry
#   Starting zookeeper
#   zookeeper is [UP]
#   Starting kafka
#   kafka is [UP]
#   Starting schema-registry
#   schema-registry is [UP]
#   [vagrant@centos7clean01 ~]$  confluent stop schema-registry
#   Stopping connect
#   connect is [DOWN]
#   Stopping kafka-rest
#   kafka-rest is [DOWN]
#   Stopping schema-registry
#   schema-registry is [DOWN]
#   [vagrant@centos7clean01 ~]$


