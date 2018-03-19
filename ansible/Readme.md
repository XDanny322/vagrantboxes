# Ansible VBox

This is my personal ansible sand box. Ansible in this case is installed via pip, and ran via the vagrant user, and not root, to sure there are no root powers needed.

The way this repo was designed, you should be able to edit the play/config_mgr directory. All the playbooks will auto rsync into the VM, under `/vagrant`

## Configs
Configs of Ansible are controlled by a few files in order of president

- ANSIBLE_CONFIG (an environment variable)
- ansible.cfg (in the current directory)
- .ansible.cfg (in the home directory)
- /etc/ansible/ansible.cfg

See [here](http://docs.ansible.com/ansible/latest/intro_configuration.html)

Also, you can overwrite specific ones by adding environment variables
- `export ANSIBLE_HOST_KEY_CHECKING=True`

## Windows Server
When trying to test on windows boxes, using http (and not https), on the windows box, you will need to enabled winrm to use unencrypted traffic. See [here](http://nokitel.im/index.php/2016/11/09/how-to-manage-windows-server-2016-with-ansible/)

To do that:
```
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
```

Note that, it seems like Win2k16 has unencrypted winrm ON by default, where win2k12r2 does not.  In another word, the above only needs to be ran on win2k12 setups.

## Workflow
```
[vagrant@ansiblecontrol ~]$ ll
total 0
drwxrwxr-x. 5 vagrant vagrant 82 Mar  9 04:06 venv
[vagrant@ansiblecontrol ~]$ source venv/bin/activate
(venv) [vagrant@ansiblecontrol ~]$
(venv) [vagrant@ansiblecontrol ~]$ cd /vagrant/
(venv) [vagrant@ansiblecontrol vagrant]$ ll
total 16
drwxr-xr-x. 2 vagrant vagrant 4096 Mar  9 00:39 ansible_rpms
drwxr-xr-x. 2 vagrant vagrant   19 Mar  9 04:07 plays
-rw-r--r--. 1 vagrant vagrant  406 Mar  9 04:14 Readme.md
-rw-r--r--. 1 vagrant vagrant  239 Mar  9 03:45 requirements.txt
-rw-r--r--. 1 vagrant vagrant  488 Mar  9 03:53 Vagrantfile
(venv) [vagrant@ansiblecontrol vagrant]$ find plays/
plays/
plays/hosts
(venv) [vagrant@ansiblecontrol vagrant]$ cat plays/hosts
[dev]
192.168.56.109
(venv) [vagrant@ansiblecontrol vagrant]$
```

## Ping boxes, on first long
```
Sat Mar 10 10:57:26 ~/vagrant/ansible(master) > vagrant ssh ansiblectrl
[vagrant@ansiblectrl ~]$ source venv/bin/activate
(venv) [vagrant@ansiblectrl ~]$ cd /vagrant/
(venv) [vagrant@ansiblectrl vagrant]$ ll
total 20
drwxr-xr-x. 2 vagrant vagrant 4096 Mar  9 00:39 ansible_rpms
drwxr-xr-x. 2 vagrant vagrant   19 Mar  9 04:07 playbooks
-rw-r--r--. 1 vagrant vagrant 5830 Mar 10 05:00 Readme.md
-rw-r--r--. 1 vagrant vagrant  239 Mar  9 03:45 requirements.txt
-rw-r--r--. 1 vagrant vagrant 1802 Mar 10 15:50 Vagrantfile
(venv) [vagrant@ansiblectrl vagrant]$ cd playbooks/
(venv) [vagrant@ansiblectrl playbooks]$ ll
total 4
-rw-r--r--. 1 vagrant vagrant 503 Mar 10 15:51 hosts
(venv) [vagrant@ansiblectrl playbooks]$ ansible all -i ./hosts -u vagrant -m ping -k
SSH password:
ansibleslve02 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
ansibleslve01 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
ansiblectrl | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
(venv) [vagrant@ansiblectrl playbooks]$

```

## Ping box, asking for password
```
ansible all -i inventory/non-production/inventory_nonprod  -m ping --ask-pass
```

## Ping box, asking for password, and su password
```
ansible-playbook site.yml -i inventory/non-production/inventory  --ask-pass --ask-become-pass
```

## Reboot
```
(venv) [vagrant@ansiblectrl01 config_mgr]$ ansible webserver01 -i inventory/production/inventory -m command -a " /sbin/shutdown -r +1" --become --become-method=sudo --ask-become-pass
SUDO password:
 [WARNING]: Module invocation had junk after the JSON data:   Broadcast message from root@webserver01 (Mon 2018-03-19 03:43:17 UTC):    The system is
going down for reboot at Mon 2018-03-19 03:44:17 UTC!

webserver01 | SUCCESS | rc=0 >>
Shutdown scheduled for Mon 2018-03-19 03:44:17 UTC, use 'shutdown -c' to cancel.

(venv) [vagrant@ansiblectrl01 config_mgr]$ ansible webserver01 -i inventory/production/inventory -m command -a "w"
webserver01 | SUCCESS | rc=0 >>
 03:45:00 up 0 min,  1 user,  load average: 0.54, 0.17, 0.06
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
vagrant  pts/0    192.168.56.126   03:45    0.00s  0.11s  0.02s w

(venv) [vagrant@ansiblectrl01 config_mgr]$
```

## Windows command
```
(venv) [vagrant@ansiblectrl01 config_mgr]$ ansible windows_group -m raw -a "dir"
win2k12db01 | SUCCESS | rc=0 >>


    Directory: C:\Users\vagrant


Mode                LastWriteTime     Length Name
----                -------------     ------ ----
d-r--         2/16/2017   4:37 PM            Contacts
d-r--         2/16/2017   4:37 PM            Desktop
d-r--         2/16/2017   4:37 PM            Documents
d-r--         2/16/2017   4:37 PM            Downloads
d-r--         2/16/2017   4:37 PM            Favorites
d-r--         2/16/2017   4:37 PM            Links
d-r--         2/16/2017   4:37 PM            Music
d-r--         2/16/2017   4:37 PM            Pictures
d-r--         2/16/2017   4:37 PM            Saved Games
d-r--         2/16/2017   4:37 PM            Searches
d-r--         2/16/2017   4:37 PM            Videos
-a---         2/16/2017   4:38 PM          6 .vbox_version
-a---         2/16/2017   4:39 PM   59369472 VBoxGuestAdditions.iso

(venv) [vagrant@ansiblectrl01 config_mgr]$
```

## Window Service
```
(venv) [vagrant@ansiblectrl01 config_mgr]$ ansible windows_group -m win_service -a "name=spooler"
win2k12db01 | SUCCESS => {
    "can_pause_and_continue": false,
    "changed": true,
    "depended_by": [],
    "dependencies": [
        "RPCSS",
        "http"
    ],
    "description": "This service spools print jobs and handles interaction with the printer.  If you turn off this service, you won’t be able to print or see your printers.",
    "desktop_interact": false,
    "display_name": "Print Spooler",
    "exists": true,
    "name": "spooler",
    "path": "C:\\Windows\\System32\\spoolsv.exe",
    "start_mode": "auto",
    "state": "running",
    "username": "LocalSystem"
}
(venv) [vagrant@ansiblectrl01 config_mgr]$
(venv) [vagrant@ansiblectrl01 config_mgr]$ ansible windows_group -m win_service -a "name=spooler state=stopped"
win2k12db01 | SUCCESS => {
    "can_pause_and_continue": false,
    "changed": true,
    "depended_by": [],
    "dependencies": [
        "RPCSS",
        "http"
    ],
    "description": "This service spools print jobs and handles interaction with the printer.  If you turn off this service, you won’t be able to print or see your printers.",
    "desktop_interact": false,
    "display_name": "Print Spooler",
    "exists": true,
    "name": "spooler",
    "path": "C:\\Windows\\System32\\spoolsv.exe",
    "start_mode": "auto",
    "state": "stopped",
    "username": "LocalSystem"
}
(venv) [vagrant@ansiblectrl01 config_mgr]$ ansible windows_group -m win_service -a "name=spooler state=start"
win2k12db01 | FAILED! => {
    "changed": false,
    "msg": "Get-AnsibleParam: Argument state needs to be one of started,stopped,restarted,absent,paused but was start."
}
(venv) [vagrant@ansiblectrl01 config_mgr]$ ansible windows_group -m win_service -a "name=spooler state=started"
win2k12db01 | SUCCESS => {
    "can_pause_and_continue": false,
    "changed": true,
    "depended_by": [],
    "dependencies": [
        "RPCSS",
        "http"
    ],
    "description": "This service spools print jobs and handles interaction with the printer.  If you turn off this service, you won’t be able to print or see your printers.",
    "desktop_interact": false,
    "display_name": "Print Spooler",
    "exists": true,
    "name": "spooler",
    "path": "C:\\Windows\\System32\\spoolsv.exe",
    "start_mode": "auto",
    "state": "running",
    "username": "LocalSystem"
}
(venv) [vagrant@ansiblectrl01 config_mgr]$
(venv) [vagrant@ansiblectrl01 config_mgr]$ ansible windows_group -m win_feature -a "name=Telnet-Client state=present"
win2k12db01 | SUCCESS => {
    "changed": true,
    "exitcode": "Success",
    "feature_result": [
        {
            "display_name": "Telnet Client",
            "id": 44,
            "message": [],
            "reboot_required": false,
            "restart_needed": false,
            "skip_reason": "NotSkipped",
            "success": true
        }
    ],
    "reboot_required": false,
    "restart_needed": false,
    "success": true
}
(venv) [vagrant@ansiblectrl01 config_mgr]$

```

## Verbose Info
```
(venv) [vagrant@ansiblecontrol plays]$ ansible all -i ./hosts -u vagrant -m ping -k -vvv
ansible 2.4.3.0
  config file = None
  configured module search path = [u'/home/vagrant/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
  ansible python module location = /home/vagrant/venv/lib/python2.7/site-packages/ansible
  executable location = /home/vagrant/venv/bin/ansible
  python version = 2.7.5 (default, Aug  4 2017, 00:39:18) [GCC 4.8.5 20150623 (Red Hat 4.8.5-16)]
No config file found; using defaults
SSH password:
Parsed /vagrant/plays/hosts inventory source with ini plugin
META: ran handlers
Using module file /home/vagrant/venv/lib/python2.7/site-packages/ansible/modules/system/ping.py
<192.168.56.109> ESTABLISH SSH CONNECTION FOR USER: vagrant
Using module file /home/vagrant/venv/lib/python2.7/site-packages/ansible/modules/system/ping.py
<127.0.0.1> ESTABLISH SSH CONNECTION FOR USER: vagrant
<192.168.56.109> SSH: EXEC sshpass -d14 ssh -C -o ControlMaster=auto -o ControlPersist=60s -o User=vagrant -o ConnectTimeout=10 -o ControlPath=/home/vagrant/.ansible/cp/fec23c08ac 192.168.56.109 '/bin/sh -c '"'"'echo ~ && sleep 0'"'"''
<127.0.0.1> SSH: EXEC sshpass -d15 ssh -C -o ControlMaster=auto -o ControlPersist=60s -o User=vagrant -o ConnectTimeout=10 -o ControlPath=/home/vagrant/.ansible/cp/9aaf07af1f 127.0.0.1 '/bin/sh -c '"'"'echo ~ && sleep 0'"'"''
<192.168.56.109> (0, '/home/vagrant\n', '')
<192.168.56.109> ESTABLISH SSH CONNECTION FOR USER: vagrant
<192.168.56.109> SSH: EXEC sshpass -d14 ssh -C -o ControlMaster=auto -o ControlPersist=60s -o User=vagrant -o ConnectTimeout=10 -o ControlPath=/home/vagrant/.ansible/cp/fec23c08ac 192.168.56.109 '/bin/sh -c '"'"'( umask 77 && mkdir -p "` echo /home/vagrant/.ansible/tmp/ansible-tmp-1520656347.0-250800740860556 `" && echo ansible-tmp-1520656347.0-250800740860556="` echo /home/vagrant/.ansible/tmp/ansible-tmp-1520656347.0-250800740860556 `" ) && sleep 0'"'"''
<127.0.0.1> (255, '', 'Permission denied (publickey,gssapi-keyex,gssapi-with-mic).\r\n')
<192.168.56.109> (0, 'ansible-tmp-1520656347.0-250800740860556=/home/vagrant/.ansible/tmp/ansible-tmp-1520656347.0-250800740860556\n', '')
<192.168.56.109> PUT /tmp/tmp_JYEm3 TO /home/vagrant/.ansible/tmp/ansible-tmp-1520656347.0-250800740860556/ping.py
<192.168.56.109> SSH: EXEC sshpass -d14 sftp -o BatchMode=no -b - -C -o ControlMaster=auto -o ControlPersist=60s -o User=vagrant -o ConnectTimeout=10 -o ControlPath=/home/vagrant/.ansible/cp/fec23c08ac '[192.168.56.109]'
127.0.0.1 | UNREACHABLE! => {
    "changed": false,
    "msg": "Failed to connect to the host via ssh: Permission denied (publickey,gssapi-keyex,gssapi-with-mic).\r\n",
    "unreachable": true
}
<192.168.56.109> (0, 'sftp> put /tmp/tmp_JYEm3 /home/vagrant/.ansible/tmp/ansible-tmp-1520656347.0-250800740860556/ping.py\n', '')
<192.168.56.109> ESTABLISH SSH CONNECTION FOR USER: vagrant
<192.168.56.109> SSH: EXEC sshpass -d14 ssh -C -o ControlMaster=auto -o ControlPersist=60s -o User=vagrant -o ConnectTimeout=10 -o ControlPath=/home/vagrant/.ansible/cp/fec23c08ac 192.168.56.109 '/bin/sh -c '"'"'chmod u+x /home/vagrant/.ansible/tmp/ansible-tmp-1520656347.0-250800740860556/ /home/vagrant/.ansible/tmp/ansible-tmp-1520656347.0-250800740860556/ping.py && sleep 0'"'"''
<192.168.56.109> (0, '', '')
<192.168.56.109> ESTABLISH SSH CONNECTION FOR USER: vagrant
<192.168.56.109> SSH: EXEC sshpass -d14 ssh -C -o ControlMaster=auto -o ControlPersist=60s -o User=vagrant -o ConnectTimeout=10 -o ControlPath=/home/vagrant/.ansible/cp/fec23c08ac -tt 192.168.56.109 '/bin/sh -c '"'"'/usr/bin/python /home/vagrant/.ansible/tmp/ansible-tmp-1520656347.0-250800740860556/ping.py; rm -rf "/home/vagrant/.ansible/tmp/ansible-tmp-1520656347.0-250800740860556/" > /dev/null 2>&1 && sleep 0'"'"''
<192.168.56.109> (0, '\r\n{"invocation": {"module_args": {"data": "pong"}}, "ping": "pong"}\r\n', 'Shared connection to 192.168.56.109 closed.\r\n')
192.168.56.109 | SUCCESS => {
    "changed": false,
    "invocation": {
        "module_args": {
            "data": "pong"
        }
    },
    "ping": "pong"
}
META: ran handlers
META: ran handlers
(venv) [vagrant@ansiblecontrol plays]$
```

## Command module
```
(venv) [vagrant@ansiblecontrol plays]$ ansible all -i ./hosts -u vagrant -m command -a "hostname -f" -k
SSH password:
127.0.0.1 | UNREACHABLE! => {
    "changed": false,
    "msg": "Failed to connect to the host via ssh: Permission denied (publickey,gssapi-keyex,gssapi-with-mic).\r\n",
    "unreachable": true
}
192.168.56.109 | SUCCESS | rc=0 >>
centos7devenv

(venv) [vagrant@ansiblecontrol plays]$
```

## Ansible adhoc commands

With Ansible, its possible to make adhoc calls, with variables.  See structure below. with the below 'group_vars' and 'host_vars' are special 'folder' used to house variables.  In order of priority host specific supersedes groups.

```
(venv) [vagrant@ansiblectrl01 config_mgr]$ tree -C
.
├── ansible.cfg
└── inventory
    ├── production
    │   ├── group_vars
    │   │   ├── all
    │   │   ├── ansiblectrl_group
    │   │   └── ansibleslve_group
    │   ├── host_vars
    │   │   ├── ansiblectrl01
    │   │   ├── ansibleslve01
    │   │   └── ansibleslve02
    │   └── inventory_prod
    └── test
        ├── group_vars
        │   ├── all
        │   ├── ansiblectrl_group
        │   └── ansibleslve_group
        ├── host_vars
        │   ├── ansiblectrl01
        │   ├── ansibleslve01
        │   └── ansibleslve02
        └── inventory_prod

7 directories, 15 files
(venv) [vagrant@ansiblectrl01 config_mgr]$
```

Also, note that it is possible to layout the structure differently as this is just one suggestion.

This is to test the variable

```
(venv) [vagrant@ansiblectrl01 config_mgr]$ ansible datacenter -i inventory/production/inventory_prod -m command -a "echo {{username}}"
ansibleslve01 | SUCCESS | rc=0 >>
slave_var

ansibleslve02 | SUCCESS | rc=0 >>
slave_var

ansiblectrl01 | SUCCESS | rc=0 >>
node_var

(venv) [vagrant@ansiblectrl01 config_mgr]$
```

## Facts

This is how you call for facts:
```

(venv) [vagrant@ansiblectrl01 config_mgr]$  ansible ansiblectrl01 -i inventory/production/inventory_prod -m setup -a "filter=*hostname*"
ansiblectrl01 | SUCCESS => {
    "ansible_facts": {
        "ansible_hostname": "ansiblectrl01"
    },
    "changed": false
}
(venv) [vagrant@ansiblectrl01 config_mgr]$



(venv) [vagrant@ansiblectrl01 config_mgr]$  ansible ansiblectrl01 -i inventory/production/inventory_prod -m setup
ansiblectrl01 | SUCCESS => {
    "ansible_facts": {
        "ansible_all_ipv4_addresses": [
            "192.168.86.69",
            "10.0.2.15",
            "192.168.56.126"
        ],
        "ansible_all_ipv6_addresses": [
            "fe80::a00:27ff:feeb:6efa",
            "fe80::5054:ff:fead:3b43",
            "fe80::a00:27ff:fec5:7eb9"
        ],
        "ansible_apparmor": {
            "status": "disabled"
        },
        "ansible_architecture": "x86_64",
        "ansible_bios_date": "12/01/2006",
        "ansible_bios_version": "VirtualBox",
        "ansible_cmdline": {
            "BOOT_IMAGE": "/vmlinuz-3.10.0-693.11.6.el7.x86_64",
            "biosdevname": "0",
            "console": "ttyS0,115200n8",
            "crashkernel": "auto",
            "net.ifnames": "0",
            "no_timer_check": true,
            "quiet": true,
            "rd.lvm.lv": "VolGroup00/LogVol01",
            "rhgb": true,
            "ro": true,
            "root": "/dev/mapper/VolGroup00-LogVol00"
        },
        "ansible_date_time": {
            "date": "2018-03-11",
            "day": "11",
            "epoch": "1520744474",
            "hour": "05",
            "iso8601": "2018-03-11T05:01:14Z",
            "iso8601_basic": "20180311T050114828568",
            "iso8601_basic_short": "20180311T050114",
            "iso8601_micro": "2018-03-11T05:01:14.828671Z",
            "minute": "01",
            "month": "03",
            "second": "14",
            "time": "05:01:14",
            "tz": "UTC",
            "tz_offset": "+0000",
            "weekday": "Sunday",
            "weekday_number": "0",
            "weeknumber": "10",
            "year": "2018"
        },
        "ansible_default_ipv4": {
            "address": "10.0.2.15",
            "alias": "eth0",
            "broadcast": "10.0.2.255",
            "gateway": "10.0.2.2",
            "interface": "eth0",
            "macaddress": "52:54:00:ad:3b:43",
            "mtu": 1500,
            "netmask": "255.255.255.0",
            "network": "10.0.2.0",
            "type": "ether"
        },
        "ansible_default_ipv6": {},
        "ansible_device_links": {
            "ids": {
                "dm-0": [
                    "dm-name-VolGroup00-LogVol00",
                    "dm-uuid-LVM-I080mT2MzkXp2nq89D2X8JFd061H1CUCgqFct1q2eW5I7aIQl2g2VmNsiqB2CqHo"
                ],
                "dm-1": [
                    "dm-name-VolGroup00-LogVol01",
                    "dm-uuid-LVM-I080mT2MzkXp2nq89D2X8JFd061H1CUCT8lHubuZnxCX9A354ZJd3PfTPqdve374"
                ],
                "sda": [
                    "ata-VBOX_HARDDISK_VB6a9c1fb3-a4754e1c"
                ],
                "sda1": [
                    "ata-VBOX_HARDDISK_VB6a9c1fb3-a4754e1c-part1"
                ],
                "sda2": [
                    "ata-VBOX_HARDDISK_VB6a9c1fb3-a4754e1c-part2"
                ],
                "sda3": [
                    "ata-VBOX_HARDDISK_VB6a9c1fb3-a4754e1c-part3",
                    "lvm-pv-uuid-qGTgpA-Amb9-J2GQ-bP3A-2X6n-g5Ud-zPWx6a"
                ]
            },
            "labels": {},
            "masters": {
                "sda3": [
                    "dm-0",
                    "dm-1"
                ]
            },
            "uuids": {
                "dm-0": [
                    "3ac2b526-6c37-46f7-8539-67bc4e55dd49"
                ],
                "dm-1": [
                    "a3a3aa2b-58b8-4ffc-b5e3-47192da3df71"
                ],
                "sda2": [
                    "1539acb0-0589-4eae-a0a4-24566186e425"
                ]
            }
        },
        "ansible_devices": {
            "dm-0": {
                "holders": [],
                "host": "",
                "links": {
                    "ids": [
                        "dm-name-VolGroup00-LogVol00",
                        "dm-uuid-LVM-I080mT2MzkXp2nq89D2X8JFd061H1CUCgqFct1q2eW5I7aIQl2g2VmNsiqB2CqHo"
                    ],
                    "labels": [],
                    "masters": [],
                    "uuids": [
                        "3ac2b526-6c37-46f7-8539-67bc4e55dd49"
                    ]
                },
                "model": null,
                "partitions": {},
                "removable": "0",
                "rotational": "1",
                "sas_address": null,
                "sas_device_handle": null,
                "scheduler_mode": "",
                "sectors": "78577664",
                "sectorsize": "512",
                "size": "37.47 GB",
                "support_discard": "0",
                "vendor": null,
                "virtual": 1
            },
            "dm-1": {
                "holders": [],
                "host": "",
                "links": {
                    "ids": [
                        "dm-name-VolGroup00-LogVol01",
                        "dm-uuid-LVM-I080mT2MzkXp2nq89D2X8JFd061H1CUCT8lHubuZnxCX9A354ZJd3PfTPqdve374"
                    ],
                    "labels": [],
                    "masters": [],
                    "uuids": [
                        "a3a3aa2b-58b8-4ffc-b5e3-47192da3df71"
                    ]
                },
                "model": null,
                "partitions": {},
                "removable": "0",
                "rotational": "1",
                "sas_address": null,
                "sas_device_handle": null,
                "scheduler_mode": "",
                "sectors": "3145728",
                "sectorsize": "512",
                "size": "1.50 GB",
                "support_discard": "0",
                "vendor": null,
                "virtual": 1
            },
            "sda": {
                "holders": [],
                "host": "",
                "links": {
                    "ids": [
                        "ata-VBOX_HARDDISK_VB6a9c1fb3-a4754e1c"
                    ],
                    "labels": [],
                    "masters": [],
                    "uuids": []
                },
                "model": "VBOX HARDDISK",
                "partitions": {
                    "sda1": {
                        "holders": [],
                        "links": {
                            "ids": [
                                "ata-VBOX_HARDDISK_VB6a9c1fb3-a4754e1c-part1"
                            ],
                            "labels": [],
                            "masters": [],
                            "uuids": []
                        },
                        "sectors": "2048",
                        "sectorsize": 512,
                        "size": "1.00 MB",
                        "start": "2048",
                        "uuid": null
                    },
                    "sda2": {
                        "holders": [],
                        "links": {
                            "ids": [
                                "ata-VBOX_HARDDISK_VB6a9c1fb3-a4754e1c-part2"
                            ],
                            "labels": [],
                            "masters": [],
                            "uuids": [
                                "1539acb0-0589-4eae-a0a4-24566186e425"
                            ]
                        },
                        "sectors": "2097152",
                        "sectorsize": 512,
                        "size": "1.00 GB",
                        "start": "4096",
                        "uuid": "1539acb0-0589-4eae-a0a4-24566186e425"
                    },
                    "sda3": {
                        "holders": [
                            "VolGroup00-LogVol00",
                            "VolGroup00-LogVol01"
                        ],
                        "links": {
                            "ids": [
                                "ata-VBOX_HARDDISK_VB6a9c1fb3-a4754e1c-part3",
                                "lvm-pv-uuid-qGTgpA-Amb9-J2GQ-bP3A-2X6n-g5Ud-zPWx6a"
                            ],
                            "labels": [],
                            "masters": [
                                "dm-0",
                                "dm-1"
                            ],
                            "uuids": []
                        },
                        "sectors": "81784832",
                        "sectorsize": 512,
                        "size": "39.00 GB",
                        "start": "2101248",
                        "uuid": null
                    }
                },
                "removable": "0",
                "rotational": "1",
                "sas_address": null,
                "sas_device_handle": null,
                "scheduler_mode": "cfq",
                "sectors": "83886080",
                "sectorsize": "512",
                "size": "40.00 GB",
                "support_discard": "0",
                "vendor": "ATA",
                "virtual": 1
            }
        },
        "ansible_distribution": "CentOS",
        "ansible_distribution_file_parsed": true,
        "ansible_distribution_file_path": "/etc/redhat-release",
        "ansible_distribution_file_variety": "RedHat",
        "ansible_distribution_major_version": "7",
        "ansible_distribution_release": "Core",
        "ansible_distribution_version": "7.4.1708",
        "ansible_dns": {
            "nameservers": [
                "10.0.2.3",
                "192.168.86.1"
            ],
            "search": [
                "lan"
            ]
        },
        "ansible_domain": "",
        "ansible_effective_group_id": 1000,
        "ansible_effective_user_id": 1000,
        "ansible_env": {
            "HOME": "/home/vagrant",
            "LANG": "en_US.UTF-8",
            "LESSOPEN": "||/usr/bin/lesspipe.sh %s",
            "LOGNAME": "vagrant",
            "LS_COLORS": "rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=01;05;37;41:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=01;36:*.au=01;36:*.flac=01;36:*.mid=01;36:*.midi=01;36:*.mka=01;36:*.mp3=01;36:*.mpc=01;36:*.ogg=01;36:*.ra=01;36:*.wav=01;36:*.axa=01;36:*.oga=01;36:*.spx=01;36:*.xspf=01;36:",
            "MAIL": "/var/mail/vagrant",
            "PATH": "/usr/local/bin:/usr/bin",
            "PWD": "/home/vagrant",
            "SELINUX_LEVEL_REQUESTED": "",
            "SELINUX_ROLE_REQUESTED": "",
            "SELINUX_USE_CURRENT_RANGE": "",
            "SHELL": "/bin/bash",
            "SHLVL": "2",
            "SSH_CLIENT": "127.0.0.1 52556 22",
            "SSH_CONNECTION": "127.0.0.1 52556 127.0.0.1 22",
            "SSH_TTY": "/dev/pts/4",
            "TERM": "xterm",
            "USER": "vagrant",
            "XDG_RUNTIME_DIR": "/run/user/1000",
            "XDG_SESSION_ID": "127",
            "_": "/usr/bin/python"
        },
        "ansible_eth0": {
            "active": true,
            "device": "eth0",
            "features": {
                "busy_poll": "off [fixed]",
                "fcoe_mtu": "off [fixed]",
                "generic_receive_offload": "on",
                "generic_segmentation_offload": "on",
                "highdma": "off [fixed]",
                "hw_tc_offload": "off [fixed]",
                "l2_fwd_offload": "off [fixed]",
                "large_receive_offload": "off [fixed]",
                "loopback": "off [fixed]",
                "netns_local": "off [fixed]",
                "ntuple_filters": "off [fixed]",
                "receive_hashing": "off [fixed]",
                "rx_all": "off",
                "rx_checksumming": "off",
                "rx_fcs": "off",
                "rx_vlan_filter": "on [fixed]",
                "rx_vlan_offload": "on",
                "rx_vlan_stag_filter": "off [fixed]",
                "rx_vlan_stag_hw_parse": "off [fixed]",
                "scatter_gather": "on",
                "tcp_segmentation_offload": "on",
                "tx_checksum_fcoe_crc": "off [fixed]",
                "tx_checksum_ip_generic": "on",
                "tx_checksum_ipv4": "off [fixed]",
                "tx_checksum_ipv6": "off [fixed]",
                "tx_checksum_sctp": "off [fixed]",
                "tx_checksumming": "on",
                "tx_fcoe_segmentation": "off [fixed]",
                "tx_gre_csum_segmentation": "off [fixed]",
                "tx_gre_segmentation": "off [fixed]",
                "tx_gso_partial": "off [fixed]",
                "tx_gso_robust": "off [fixed]",
                "tx_ipip_segmentation": "off [fixed]",
                "tx_lockless": "off [fixed]",
                "tx_mpls_segmentation": "off [fixed]",
                "tx_nocache_copy": "off",
                "tx_scatter_gather": "on",
                "tx_scatter_gather_fraglist": "off [fixed]",
                "tx_sctp_segmentation": "off [fixed]",
                "tx_sit_segmentation": "off [fixed]",
                "tx_tcp6_segmentation": "off [fixed]",
                "tx_tcp_ecn_segmentation": "off [fixed]",
                "tx_tcp_mangleid_segmentation": "off",
                "tx_tcp_segmentation": "on",
                "tx_udp_tnl_csum_segmentation": "off [fixed]",
                "tx_udp_tnl_segmentation": "off [fixed]",
                "tx_vlan_offload": "on [fixed]",
                "tx_vlan_stag_hw_insert": "off [fixed]",
                "udp_fragmentation_offload": "off [fixed]",
                "vlan_challenged": "off [fixed]"
            },
            "hw_timestamp_filters": [],
            "ipv4": {
                "address": "10.0.2.15",
                "broadcast": "10.0.2.255",
                "netmask": "255.255.255.0",
                "network": "10.0.2.0"
            },
            "ipv6": [
                {
                    "address": "fe80::5054:ff:fead:3b43",
                    "prefix": "64",
                    "scope": "link"
                }
            ],
            "macaddress": "52:54:00:ad:3b:43",
            "module": "e1000",
            "mtu": 1500,
            "pciid": "0000:00:03.0",
            "promisc": false,
            "speed": 1000,
            "timestamping": [
                "tx_software",
                "rx_software",
                "software"
            ],
            "type": "ether"
        },
        "ansible_eth1": {
            "active": true,
            "device": "eth1",
            "features": {
                "busy_poll": "off [fixed]",
                "fcoe_mtu": "off [fixed]",
                "generic_receive_offload": "on",
                "generic_segmentation_offload": "on",
                "highdma": "off [fixed]",
                "hw_tc_offload": "off [fixed]",
                "l2_fwd_offload": "off [fixed]",
                "large_receive_offload": "off [fixed]",
                "loopback": "off [fixed]",
                "netns_local": "off [fixed]",
                "ntuple_filters": "off [fixed]",
                "receive_hashing": "off [fixed]",
                "rx_all": "off",
                "rx_checksumming": "off",
                "rx_fcs": "off",
                "rx_vlan_filter": "on [fixed]",
                "rx_vlan_offload": "on",
                "rx_vlan_stag_filter": "off [fixed]",
                "rx_vlan_stag_hw_parse": "off [fixed]",
                "scatter_gather": "on",
                "tcp_segmentation_offload": "on",
                "tx_checksum_fcoe_crc": "off [fixed]",
                "tx_checksum_ip_generic": "on",
                "tx_checksum_ipv4": "off [fixed]",
                "tx_checksum_ipv6": "off [fixed]",
                "tx_checksum_sctp": "off [fixed]",
                "tx_checksumming": "on",
                "tx_fcoe_segmentation": "off [fixed]",
                "tx_gre_csum_segmentation": "off [fixed]",
                "tx_gre_segmentation": "off [fixed]",
                "tx_gso_partial": "off [fixed]",
                "tx_gso_robust": "off [fixed]",
                "tx_ipip_segmentation": "off [fixed]",
                "tx_lockless": "off [fixed]",
                "tx_mpls_segmentation": "off [fixed]",
                "tx_nocache_copy": "off",
                "tx_scatter_gather": "on",
                "tx_scatter_gather_fraglist": "off [fixed]",
                "tx_sctp_segmentation": "off [fixed]",
                "tx_sit_segmentation": "off [fixed]",
                "tx_tcp6_segmentation": "off [fixed]",
                "tx_tcp_ecn_segmentation": "off [fixed]",
                "tx_tcp_mangleid_segmentation": "off",
                "tx_tcp_segmentation": "on",
                "tx_udp_tnl_csum_segmentation": "off [fixed]",
                "tx_udp_tnl_segmentation": "off [fixed]",
                "tx_vlan_offload": "on [fixed]",
                "tx_vlan_stag_hw_insert": "off [fixed]",
                "udp_fragmentation_offload": "off [fixed]",
                "vlan_challenged": "off [fixed]"
            },
            "hw_timestamp_filters": [],
            "ipv4": {
                "address": "192.168.86.69",
                "broadcast": "192.168.86.255",
                "netmask": "255.255.255.0",
                "network": "192.168.86.0"
            },
            "ipv6": [
                {
                    "address": "fe80::a00:27ff:feeb:6efa",
                    "prefix": "64",
                    "scope": "link"
                }
            ],
            "macaddress": "08:00:27:eb:6e:fa",
            "module": "e1000",
            "mtu": 1500,
            "pciid": "0000:00:08.0",
            "promisc": false,
            "speed": 1000,
            "timestamping": [
                "tx_software",
                "rx_software",
                "software"
            ],
            "type": "ether"
        },
        "ansible_eth2": {
            "active": true,
            "device": "eth2",
            "features": {
                "busy_poll": "off [fixed]",
                "fcoe_mtu": "off [fixed]",
                "generic_receive_offload": "on",
                "generic_segmentation_offload": "on",
                "highdma": "off [fixed]",
                "hw_tc_offload": "off [fixed]",
                "l2_fwd_offload": "off [fixed]",
                "large_receive_offload": "off [fixed]",
                "loopback": "off [fixed]",
                "netns_local": "off [fixed]",
                "ntuple_filters": "off [fixed]",
                "receive_hashing": "off [fixed]",
                "rx_all": "off",
                "rx_checksumming": "off",
                "rx_fcs": "off",
                "rx_vlan_filter": "on [fixed]",
                "rx_vlan_offload": "on",
                "rx_vlan_stag_filter": "off [fixed]",
                "rx_vlan_stag_hw_parse": "off [fixed]",
                "scatter_gather": "on",
                "tcp_segmentation_offload": "on",
                "tx_checksum_fcoe_crc": "off [fixed]",
                "tx_checksum_ip_generic": "on",
                "tx_checksum_ipv4": "off [fixed]",
                "tx_checksum_ipv6": "off [fixed]",
                "tx_checksum_sctp": "off [fixed]",
                "tx_checksumming": "on",
                "tx_fcoe_segmentation": "off [fixed]",
                "tx_gre_csum_segmentation": "off [fixed]",
                "tx_gre_segmentation": "off [fixed]",
                "tx_gso_partial": "off [fixed]",
                "tx_gso_robust": "off [fixed]",
                "tx_ipip_segmentation": "off [fixed]",
                "tx_lockless": "off [fixed]",
                "tx_mpls_segmentation": "off [fixed]",
                "tx_nocache_copy": "off",
                "tx_scatter_gather": "on",
                "tx_scatter_gather_fraglist": "off [fixed]",
                "tx_sctp_segmentation": "off [fixed]",
                "tx_sit_segmentation": "off [fixed]",
                "tx_tcp6_segmentation": "off [fixed]",
                "tx_tcp_ecn_segmentation": "off [fixed]",
                "tx_tcp_mangleid_segmentation": "off",
                "tx_tcp_segmentation": "on",
                "tx_udp_tnl_csum_segmentation": "off [fixed]",
                "tx_udp_tnl_segmentation": "off [fixed]",
                "tx_vlan_offload": "on [fixed]",
                "tx_vlan_stag_hw_insert": "off [fixed]",
                "udp_fragmentation_offload": "off [fixed]",
                "vlan_challenged": "off [fixed]"
            },
            "hw_timestamp_filters": [],
            "ipv4": {
                "address": "192.168.56.126",
                "broadcast": "192.168.56.255",
                "netmask": "255.255.255.0",
                "network": "192.168.56.0"
            },
            "ipv6": [
                {
                    "address": "fe80::a00:27ff:fec5:7eb9",
                    "prefix": "64",
                    "scope": "link"
                }
            ],
            "macaddress": "08:00:27:c5:7e:b9",
            "module": "e1000",
            "mtu": 1500,
            "pciid": "0000:00:09.0",
            "promisc": false,
            "speed": 1000,
            "timestamping": [
                "tx_software",
                "rx_software",
                "software"
            ],
            "type": "ether"
        },
        "ansible_fips": false,
        "ansible_form_factor": "Other",
        "ansible_fqdn": "ansiblectrl01",
        "ansible_hostname": "ansiblectrl01",
        "ansible_interfaces": [
            "lo",
            "eth2",
            "eth1",
            "eth0"
        ],
        "ansible_kernel": "3.10.0-693.11.6.el7.x86_64",
        "ansible_lo": {
            "active": true,
            "device": "lo",
            "features": {
                "busy_poll": "off [fixed]",
                "fcoe_mtu": "off [fixed]",
                "generic_receive_offload": "on",
                "generic_segmentation_offload": "on",
                "highdma": "on [fixed]",
                "hw_tc_offload": "off [fixed]",
                "l2_fwd_offload": "off [fixed]",
                "large_receive_offload": "off [fixed]",
                "loopback": "on [fixed]",
                "netns_local": "on [fixed]",
                "ntuple_filters": "off [fixed]",
                "receive_hashing": "off [fixed]",
                "rx_all": "off [fixed]",
                "rx_checksumming": "on [fixed]",
                "rx_fcs": "off [fixed]",
                "rx_vlan_filter": "off [fixed]",
                "rx_vlan_offload": "off [fixed]",
                "rx_vlan_stag_filter": "off [fixed]",
                "rx_vlan_stag_hw_parse": "off [fixed]",
                "scatter_gather": "on",
                "tcp_segmentation_offload": "on",
                "tx_checksum_fcoe_crc": "off [fixed]",
                "tx_checksum_ip_generic": "on [fixed]",
                "tx_checksum_ipv4": "off [fixed]",
                "tx_checksum_ipv6": "off [fixed]",
                "tx_checksum_sctp": "on [fixed]",
                "tx_checksumming": "on",
                "tx_fcoe_segmentation": "off [fixed]",
                "tx_gre_csum_segmentation": "off [fixed]",
                "tx_gre_segmentation": "off [fixed]",
                "tx_gso_partial": "off [fixed]",
                "tx_gso_robust": "off [fixed]",
                "tx_ipip_segmentation": "off [fixed]",
                "tx_lockless": "on [fixed]",
                "tx_mpls_segmentation": "off [fixed]",
                "tx_nocache_copy": "off [fixed]",
                "tx_scatter_gather": "on [fixed]",
                "tx_scatter_gather_fraglist": "on [fixed]",
                "tx_sctp_segmentation": "on",
                "tx_sit_segmentation": "off [fixed]",
                "tx_tcp6_segmentation": "on",
                "tx_tcp_ecn_segmentation": "on",
                "tx_tcp_mangleid_segmentation": "on",
                "tx_tcp_segmentation": "on",
                "tx_udp_tnl_csum_segmentation": "off [fixed]",
                "tx_udp_tnl_segmentation": "off [fixed]",
                "tx_vlan_offload": "off [fixed]",
                "tx_vlan_stag_hw_insert": "off [fixed]",
                "udp_fragmentation_offload": "on",
                "vlan_challenged": "on [fixed]"
            },
            "hw_timestamp_filters": [],
            "ipv4": {
                "address": "127.0.0.1",
                "broadcast": "host",
                "netmask": "255.0.0.0",
                "network": "127.0.0.0"
            },
            "ipv6": [
                {
                    "address": "::1",
                    "prefix": "128",
                    "scope": "host"
                }
            ],
            "mtu": 65536,
            "promisc": false,
            "timestamping": [
                "rx_software",
                "software"
            ],
            "type": "loopback"
        },
        "ansible_local": {},
        "ansible_lsb": {},
        "ansible_machine": "x86_64",
        "ansible_machine_id": "b0a20e1944d54b8faef6f5636fe4bd61",
        "ansible_memfree_mb": 118,
        "ansible_memory_mb": {
            "nocache": {
                "free": 692,
                "used": 300
            },
            "real": {
                "free": 118,
                "total": 992,
                "used": 874
            },
            "swap": {
                "cached": 0,
                "free": 1535,
                "total": 1535,
                "used": 0
            }
        },
        "ansible_memtotal_mb": 992,
        "ansible_mounts": [
            {
                "block_available": 9552237,
                "block_size": 4096,
                "block_total": 9817412,
                "block_used": 265175,
                "device": "/dev/mapper/VolGroup00-LogVol00",
                "fstype": "xfs",
                "inode_available": 19610280,
                "inode_total": 19644416,
                "inode_used": 34136,
                "mount": "/",
                "options": "rw,seclabel,relatime,attr2,inode64,noquota",
                "size_available": 39125962752,
                "size_total": 40212119552,
                "uuid": "3ac2b526-6c37-46f7-8539-67bc4e55dd49"
            },
            {
                "block_available": 243668,
                "block_size": 4096,
                "block_total": 259584,
                "block_used": 15916,
                "device": "/dev/sda2",
                "fstype": "xfs",
                "inode_available": 523997,
                "inode_total": 524288,
                "inode_used": 291,
                "mount": "/boot",
                "options": "rw,seclabel,relatime,attr2,inode64,noquota",
                "size_available": 998064128,
                "size_total": 1063256064,
                "uuid": "1539acb0-0589-4eae-a0a4-24566186e425"
            }
        ],
        "ansible_nodename": "ansiblectrl01",
        "ansible_os_family": "RedHat",
        "ansible_pkg_mgr": "yum",
        "ansible_processor": [
            "0",
            "GenuineIntel",
            "Intel(R) Core(TM) i5-6300U CPU @ 2.40GHz"
        ],
        "ansible_processor_cores": 1,
        "ansible_processor_count": 1,
        "ansible_processor_threads_per_core": 1,
        "ansible_processor_vcpus": 1,
        "ansible_product_name": "VirtualBox",
        "ansible_product_serial": "NA",
        "ansible_product_uuid": "NA",
        "ansible_product_version": "1.2",
        "ansible_python": {
            "executable": "/usr/bin/python",
            "has_sslcontext": true,
            "type": "CPython",
            "version": {
                "major": 2,
                "micro": 5,
                "minor": 7,
                "releaselevel": "final",
                "serial": 0
            },
            "version_info": [
                2,
                7,
                5,
                "final",
                0
            ]
        },
        "ansible_python_version": "2.7.5",
        "ansible_real_group_id": 1000,
        "ansible_real_user_id": 1000,
        "ansible_selinux": {
            "config_mode": "enforcing",
            "mode": "enforcing",
            "policyvers": 28,
            "status": "enabled",
            "type": "targeted"
        },
        "ansible_selinux_python_present": true,
        "ansible_service_mgr": "systemd",
        "ansible_ssh_host_key_ecdsa_public": "AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBH7muwJvOeVUNFFe7bnOisahjb6f2zd3Lv/cs+osjV0KWEVhpoQzl8BFpcJXfNOWaBuwd5W9iuWnJNhqwT7sKL8=",
        "ansible_ssh_host_key_ed25519_public": "AAAAC3NzaC1lZDI1NTE5AAAAINeQNLBvmdocowR7rP6FXBMgbqaj3Q1UNCnL8EzLLWRe",
        "ansible_ssh_host_key_rsa_public": "AAAAB3NzaC1yc2EAAAADAQABAAABAQCmqvnBwHpBSP43mA0zEApm5IYvJPFONsAB6jVnTyfkRWnpTdTtfNvoldi7aHqLgjxG5xMcq51SXdGAnkCO8wv5IBOfhek6WG5nXryOeOEbX6+SPfPeXi/ucOLuj8H7f5EH1/GJKFMpC19v1SOS94XVzhSDgS/A5sJPdk6Z2DAgb9c7kXErP+LuWIsSA3SZUxN2K2BLvyJ25jCNpY+mrnW6NeunHfyfO7WCpMwjG/5kiJba6/9oLLMdmSm5AAlpIK1mM3FhkPMFC4wKv11B4VOxuTuNIYuO2D/FSN2owyYu+zrPZC0G94QFpQUmVPojw6Gmy5MVtxDWD8NUPOQ8gTF1",
        "ansible_swapfree_mb": 1535,
        "ansible_swaptotal_mb": 1535,
        "ansible_system": "Linux",
        "ansible_system_capabilities": [
            ""
        ],
        "ansible_system_capabilities_enforced": "True",
        "ansible_system_vendor": "innotek GmbH",
        "ansible_uptime_seconds": 20846,
        "ansible_user_dir": "/home/vagrant",
        "ansible_user_gecos": "vagrant",
        "ansible_user_gid": 1000,
        "ansible_user_id": "vagrant",
        "ansible_user_shell": "/bin/bash",
        "ansible_user_uid": 1000,
        "ansible_userspace_architecture": "x86_64",
        "ansible_userspace_bits": "64",
        "ansible_virtualization_role": "guest",
        "ansible_virtualization_type": "virtualbox",
        "gather_subset": [
            "all"
        ],
        "module_setup": true
    },
    "changed": false
}
(venv) [vagrant@ansiblectrl01 config_mgr]$

```


## Running a playbook:

```
(venv) [vagrant@ansiblectrl01 config_mgr]$ ansible-playbook -i inventory/production/inventory_prod playbooks/httpd.yaml
what is your name?:
what is your quest?:
what is your favorite color?:

PLAY [ansibleslve01] *******************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************
ok: [ansibleslve01]

TASK [Ensure that Apache is installed] *************************************************************************************************
ok: [ansibleslve01]

TASK [Start Apache Services] ***********************************************************************************************************
ok: [ansibleslve01]

TASK [Placing (touch) a test file] *****************************************************************************************************
changed: [ansibleslve01] => (item=test)
changed: [ansibleslve01] => (item=test1)
changed: [ansibleslve01] => (item=test2)

TASK [Placing a line in the test file.] ************************************************************************************************
ok: [ansibleslve01]

TASK [Debugging message] ***************************************************************************************************************
ok: [ansibleslve01] => (item=Danny) => {
    "changed": false,
    "item": "Danny",
    "msg": "This"
}
ok: [ansibleslve01] => (item=your) => {
    "changed": false,
    "item": "your",
    "msg": "This"
}
ok: [ansibleslve01] => (item=ddd) => {
    "changed": false,
    "item": "ddd",
    "msg": "This"
}
ok: [ansibleslve01] => (item=myvalue) => {
    "changed": false,
    "item": "myvalue",
    "msg": "This"
}

PLAY [ansibleslve02] *******************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************
ok: [ansibleslve02]

TASK [Ensure that Apache is installed] *************************************************************************************************
ok: [ansibleslve02]

TASK [Start Apache Services] ***********************************************************************************************************
ok: [ansibleslve02]

PLAY RECAP *****************************************************************************************************************************
ansibleslve01              : ok=6    changed=1    unreachable=0    failed=0
ansibleslve02              : ok=3    changed=0    unreachable=0    failed=0

(venv) [vagrant@ansiblectrl01 config_mgr]$

```


### Run a site.yaml

site.yaml is like a site.pp for puppet / top.sls for saltstack.

```
(venv) [vagrant@ansiblectrl01 roles]$ ansible-playbook site.yml -i /vagrant/config_mgr/inventory/production/inventory_prod

PLAY [ansibleslve01:ansibleslve02] **********************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************
ok: [ansibleslve01]
ok: [ansibleslve02]

TASK [webserver : Ensure that Apache is installed] ******************************************************************************************************************************
```
