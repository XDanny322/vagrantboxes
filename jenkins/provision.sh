#!/bin/bash
#
# provision.sh for Jenkins
########################################################################
# Install needed tools
yum -y install wget mlocate vim net-tools telnet

# Follow https://jenkins.io/download/
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

yum -y install java
yum -y install jenkins-2.89.3-1.1

systemctl start jenkins

# Using Jenkins
# https://www.tutorialspoint.com/jenkins/jenkins_tomcat_setup.htm