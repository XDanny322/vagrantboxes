#!/bin/bash
# See https://about.gitlab.com/installation/#centos-7
sudo yum install -y curl policycoreutils-python openssh-server

sudo yum install postfix
sudo systemctl enable postfix
sudo systemctl start postfix

curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.rpm.sh | sudo bash

# Reminder that
#  ee = Enterprise Ed
#  ce = Community Ed
sudo EXTERNAL_URL="http://192.168.6.133" yum install -y gitlab-ee


# # Start all GitLab components
# sudo gitlab-ctl start

# # Stop all GitLab components
# sudo gitlab-ctl stop

# # Restart all GitLab components
# sudo gitlab-ctl restart