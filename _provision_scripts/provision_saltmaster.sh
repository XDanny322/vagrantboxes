#!/bin/bash
yum -y install https://repo.saltstack.com/yum/redhat/salt-repo-latest-2.el7.noarch.rpm
yum -y install salt-master

# Enable saltmaster to list on all interfacts
sed -i 's/#interface: 0.0.0.0/interface: 0.0.0.0/g' /etc/salt/master

# Start the salt master
systemctl start salt-master.service
systemctl enable salt-master.service

# If you want a bearbone salt state | pillar
# setup, move the /srv_base dir to /srv
srvbase="/srv_base"

mkdir -p $srvbase/salt
mkdir -p $srvbase/salt/common
mkdir -p $srvbase/salt/common/states
mkdir -p $srvbase/pillar
mkdir -p $srvbase/pillar/minions

## States
echo "base:
  '*':
    - common" > $srvbase/salt/top.sls
echo "include:
  - common.states.files" > $srvbase/salt/common/init.sls
echo "Test file placement:
  file:
    - managed
    - name: /tmp/testfile
    - mode: 644
    - contents: 'Test message'" > $srvbase/salt/common/states/files.sls

## Pillar
echo "base:
  '*':
    - settings
  '{{ grains.fqdn }}':
    - ignore_missing: True
    - minions.{{ grains.fqdn | replace(\".\",\"_\") }}" >  $srvbase/pillar/top.sls
echo "roles:
- salt-master
salt-master:
  config:
    home_dir: /home/dlai
    type: local
salt-minion:
  config:
    log_level: info
    masters:
      - localhost" > $srvbase/pillar/minions/testbox_localdomain_net.sls
echo "minion_blackout: False
minion_blackout_whitelist:
  - config.get
  - file.list_backups
  - grains.item
  - grains.items
  - minion.list
  - minion.restart
  - pillar.get
  - pillar.item
  - pillar.items
  - pip.list
  - reg.read_value
  - saltutil.clear_cache
  - saltutil.find_job
  - saltutil.is_running
  - saltutil.running
  - saltutil.sync_all
  - saltutil.sync_grains
  - saltutil.sync_returners
  - saltutil.update
  - schedule.list
  - schedule.present
  - service.available
  - service.get_all
  - service.status
  - state.apply
  - state.enable
  - state.disable
  - state.highstate
  - state.sls
  - system.get_pending_reboot
  - system.get_reboot_required_witnessed
  - test.ping
  - win_wua.list
  - win_wua.get_wu_settings" > $srvbase/pillar/settings.sls

