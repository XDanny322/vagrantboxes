# Docker

Requirments:
- Get a few VMs up, likely 6 VMs
    - 3 Mgr
    - 3 Workers

# Create a swarm

```console
[vagrant@dockersvr01 ~]$ sudo docker swarm init --advertise-addr 192.168.56.134:2377 --listen-addr 192.168.56.134:2377
Swarm initialized: current node (lm4xnwrp44gwyes7zuu9buc5a) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-3nbbylc53hr3b14j19uaepdmej6nnaoivd6hsxk9hn2bn7j10b-1mqx9qho7xbrej6g5mnly2nky 192.168.56.134:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.

[vagrant@dockersvr01 ~]$
```

# Get manager join command

Remember to add the `--advertise-addr` and `--listen-addr` options, pointed to the worker IP, and not the leader's IP.

```console
[vagrant@dockersvr01 ~]$ sudo docker swarm join-token manager
To add a manager to this swarm, run the following command:

    sudo docker swarm join --token SWMTKN-1-3nbbylc53hr3b14j19uaepdmej6nnaoivd6hsxk9hn2bn7j10b-2tkz35jkekq4jauj7eh4xc3qj 192.168.56.134:2377 --advertise-addr 192.168.56.135:2377 --listen-addr 192.168.56.135:2377
```

#Join a worker

```console
[vagrant@dockersvr01 ~]$ sudo docker swarm join-token worker
To add a worker to this swarm, run the following command:

    sudo docker swarm join --token SWMTKN-1-3nbbylc53hr3b14j19uaepdmej6nnaoivd6hsxk9hn2bn7j10b-1mqx9qho7xbrej6g5mnly2nky 192.168.56.134:2377 --advertise-addr 192.168.56.136:2377 --listen-addr 192.168.56.136:2377

[vagrant@dockersvr01 ~]$
```
