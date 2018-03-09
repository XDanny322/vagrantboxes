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

## Ping localhost
```
(venv) [vagrant@ansiblecontrol ~]$ ansible -i /vagrant/plays/hosts --connection=local local -m ping
127.0.0.1 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
(venv) [vagrant@ansiblecontrol ~]$
```