# Docker

## Swarm

Requirments:
- Get a few VMs up, likely 6 VMs
    - 3 Mgr
    - 3 Workers

### Create a swarm

```console
[vagrant@dockersvr01 ~]$ sudo docker swarm init --advertise-addr 192.168.56.134:2377 --listen-addr 192.168.56.134:2377
Swarm initialized: current node (lm4xnwrp44gwyes7zuu9buc5a) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-5egh8subk5h3snk8t0e1qh2sjkr8w7ojqneqo4dzqgiqnj6vfp-17t7v6oxx3mddyk77g7pugbgs 192.168.56.134:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.

[vagrant@dockersvr01 ~]$
```

### Get manager join command

Remember to add the `--advertise-addr` and `--listen-addr` options, pointed to the worker IP, and not the leader's IP.

```console
[root@dockersvr01 ~]# docker swarm join-token manager
To add a manager to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-5egh8subk5h3snk8t0e1qh2sjkr8w7ojqneqo4dzqgiqnj6vfp-elgu9a2z9eat2br56o7se49uv 192.168.56.134:2377 --advertise-addr 192.168.56.135:2377 --listen-addr 192.168.56.135:2377
```

### Join a worker

```console
[root@dockersvr01 ~]# sudo docker swarm join-token worker
To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-5egh8subk5h3snk8t0e1qh2sjkr8w7ojqneqo4dzqgiqnj6vfp-17t7v6oxx3mddyk77g7pugbgs 192.168.56.134:2377 --advertise-addr 192.168.56.135:2377 --listen-addr 192.168.56.135:2377

[vagrant@dockersvr01 ~]$
```

### Check the swarm (via the -node- sub command)

```console
[root@dockersvr01 ~]# docker node list
ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
vbaunnrnbkh5c19mqzqabm3v0 *   dockersvr01         Ready               Active              Leader              18.09.0
ct1m2qjuutpobujgp55qhmu4f     dockersvr02         Ready               Active              Reachable           18.09.0
w6xk2vqjydd4jlkvahp284mxs     dockersvr03         Ready               Active              Reachable           18.09.0
p0qfmv5u7ojhmxupmenm8h652     dockersvr04         Ready               Active                                  18.09.0
ymh0w5omdusiqlwzfbe8e8l3v     dockersvr05         Ready               Active                                  18.09.0
hrohlq37ez4rg167ff6ytzi7c     dockersvr06         Ready               Active                                  18.09.0
[root@dockersvr01 ~]#
```

### Get docker info

See Swarm info:

```console
[root@dockersvr01 ~]# docker info
Containers: 0
 Running: 0
 Paused: 0
 Stopped: 0
Images: 0
Server Version: 18.09.0
Storage Driver: overlay2
 Backing Filesystem: extfs
 Supports d_type: true
 Native Overlay Diff: true
Logging Driver: json-file
Cgroup Driver: cgroupfs
Plugins:
 Volume: local
 Network: bridge host macvlan null overlay
 Log: awslogs fluentd gcplogs gelf journald json-file local logentries splunk syslog
Swarm: active                                                                   <<<< See here
 NodeID: vbaunnrnbkh5c19mqzqabm3v0
 Is Manager: true
 ClusterID: 6u5ekq851skebz4f4v88qdxnz
 Managers: 3
 Nodes: 6
 Default Address Pool: 10.0.0.0/8
 SubnetSize: 24
 Orchestration:
  Task History Retention Limit: 5
 Raft:
  Snapshot Interval: 10000
  Number of Old Snapshots to Retain: 0
  Heartbeat Tick: 1
  Election Tick: 10
 Dispatcher:
  Heartbeat Period: 5 seconds
 CA Configuration:
  Expiry Duration: 3 months
  Force Rotate: 0
 Autolock Managers: false
 Root Rotation In Progress: false
 Node Address: 192.168.56.134
 Manager Addresses:
  192.168.56.134:2377
  192.168.56.135:2377
  192.168.56.136:2377
Runtimes: runc
Default Runtime: runc
Init Binary: docker-init
containerd version: c4446665cb9c30056f4998ed953e6d4ff22c7c39
runc version: 4fc53a81fb7c994640722ac585fa9ca548971871
init version: fec3683
Security Options:
 seccomp
  Profile: default
Kernel Version: 3.10.0-862.14.4.el7.x86_64
Operating System: CentOS Linux 7 (Core)
OSType: linux
Architecture: x86_64
CPUs: 2
Total Memory: 1.795GiB
Name: dockersvr01
ID: BURP:G6MU:PVB4:T2RC:2G6P:6HLK:AMC5:6HAI:BR32:ZFK7:CDWL:5QCN
Docker Root Dir: /var/lib/docker
Debug Mode (client): false
Debug Mode (server): false
Registry: https://index.docker.io/v1/
Labels:
Experimental: false
Insecure Registries:
 127.0.0.0/8
Live Restore Enabled: false
Product License: Community Engine

WARNING: bridge-nf-call-ip6tables is disabled
[root@dockersvr01 ~]#
```

## Services

Services are what uses a 'swarm' to provide services

### Create a Service

Creating a Service can take a while..

```console
[root@dockersvr01 ~]# docker service create --name dlaitest1 -p 8080:8080 --replicas 5 nigelpoulton/pluralsight-docker-ci                                    wdkpj44qve6v7zz02uxc223ut
overall progress: 5 out of 5 tasks
1/5: running   [==================================================>]
2/5: running   [==================================================>]
3/5: running   [==================================================>]
4/5: running   [==================================================>]
5/5: running   [==================================================>]
verify: Service converged
[root@dockersvr01 ~]#
```

### Check service

```console
[root@dockersvr01 ~]# docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE                                       PORTS
wdkpj44qve6v        dlaitest1           replicated          5/5                 nigelpoulton/pluralsight-docker-ci:latest   *:8080->8080/tcp
[root@dockersvr01 ~]#
[root@dockersvr01 ~]#
[root@dockersvr01 ~]#
[root@dockersvr01 ~]# docker service ps dlaitest1
ID                  NAME                IMAGE                                       NODE                DESIRED STATE       CURRENT STATE               ERROR               PORTS
xfrrmh25scjf        dlaitest1.1         nigelpoulton/pluralsight-docker-ci:latest   dockersvr03         Running             Running about an hour ago
q7elvi79jrs7        dlaitest1.2         nigelpoulton/pluralsight-docker-ci:latest   dockersvr05         Running             Running about an hour ago
uhy6wl0ysh7d        dlaitest1.3         nigelpoulton/pluralsight-docker-ci:latest   dockersvr06         Running             Running about an hour ago
62ojperl4php        dlaitest1.4         nigelpoulton/pluralsight-docker-ci:latest   dockersvr01         Running             Running about an hour ago
dxn0ct7nnzxh        dlaitest1.5         nigelpoulton/pluralsight-docker-ci:latest   dockersvr02         Running             Running about an hour ago
[root@dockersvr01 ~]#
```

## Auto bring up a a node, if a working node is dead

First kill a now then check the `docker ps`

```

[root@dockersvr01 ~]# docker service ps dlaitest1
ID                  NAME                IMAGE                                       NODE                DESIRED STATE       CURRENT STATE               ERROR               PORTS
eg31b1fezwv6        dlaitest1.1         nigelpoulton/pluralsight-docker-ci:latest   dockersvr04         Running             Preparing 6 seconds ago
xfrrmh25scjf         \_ dlaitest1.1     nigelpoulton/pluralsight-docker-ci:latest   dockersvr03         Shutdown            Running 21 seconds ago
q7elvi79jrs7        dlaitest1.2         nigelpoulton/pluralsight-docker-ci:latest   dockersvr05         Running             Running about an hour ago
uhy6wl0ysh7d        dlaitest1.3         nigelpoulton/pluralsight-docker-ci:latest   dockersvr06         Running             Running about an hour ago
62ojperl4php        dlaitest1.4         nigelpoulton/pluralsight-docker-ci:latest   dockersvr01         Running             Running about an hour ago
dxn0ct7nnzxh        dlaitest1.5         nigelpoulton/pluralsight-docker-ci:latest   dockersvr02         Running             Running about an hour ago
[root@dockersvr01 ~]#
```

## Scale your service

```console
[root@dockersvr01 ~]# docker service scale dlaitest1=10
dlaitest1 scaled to 10
overall progress: 10 out of 10 tasks
1/10: running   [==================================================>]
2/10: running   [==================================================>]
3/10: running   [==================================================>]
4/10: running   [==================================================>]
5/10: running   [==================================================>]
6/10: running   [==================================================>]
7/10: running   [==================================================>]
8/10: running   [==================================================>]
9/10: running   [==================================================>]
10/10: running   [==================================================>]
verify: Service converged
[root@dockersvr01 ~]#
```

## Rolling update

I did not actually this one, but you can have rolling update, basically update from one tag to another tag, by:

`docker service update --image nigelpoulton/tu-demo:v2 --update-parallelism 2 --update-delay 1-s psight2`
