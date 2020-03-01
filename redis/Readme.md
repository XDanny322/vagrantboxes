
```console
23:10:48 redis 1[master !?] >  redis-cli -h 192.168.56.145 set name danny
OK
23:10:48 redis [master !?] >  redis-cli -h 192.168.56.145 get name
"danny"
23:10:48 redis [master !?] >  redis-cli -h 192.168.56.145 type name
string
23:10:49 redis [master !?] >
```
