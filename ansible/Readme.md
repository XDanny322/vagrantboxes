# Ansible VBox

This is my personal ansible sand box. Sourced from https://serversforhackers.com/c/an-ansible2-tutorial. Ansible in this case is installed via pip, and ran via the vagrant user, and not root, to sure there are no root powers needed.

The way this this vbox was designed, you should be able to edit the *plays* directory, and all the playbooks will auto rsync into the VM, under `/vagrant`

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