# Salt Master

This Vagrant box was made a test system for Salt's State and Piller

In order to use the salt state from "work", git clone the salt-pillar repo and salt-state repo onto the same dir as the Vagrant file. There are git ignore that will prevent it from getting pushed up to git.

To run high state, since we need the filesystem run it by: `salt '*' state.highstate saltenv=base`

## Common Commands

Salt-call, calling salt from the minion

* `salt-call  cmd.run 'ls' -l trace`
* `salt-call  cmd.run 'ls' -l debug`
* `salt '*' state.sls apache test=true`

Running sls from local file system (in /svr/salt).

* `salt-call state.sls base/motd --local`

Commands

* `salt '*' test.ping`
* `salt-call schedule.list`
* `salt-call schedule.delete test3`
* `salt-call schedule.add test3 function='cmd.run' job_args="['export PATH=\${PATH//\/opt\/factset-salt-minion\/env\/bin/} && (puppet agent --onetime --no-daemonize --verbose --environment dlai_saltrestart &)']" when='02:31am'`
* `salt-call schedule.delete test3`
* `salt-call schedule.add test3 function='grains.items' when='12:01pm' returner='systems_inventory'`
* `source /opt/factset-salt-minion/env/bin/activate`
* `salt-call state.highstate --return clp saltenv=dlai_SI_returner_debug`
* `salt-call grains.items --return systems_inventory`
* `salt-call cmd.run 'export PATH=${PATH//\/opt\/factset-salt-minion\/env\/bin/} && puppet agent --onetime --no-daemonize --verbose'`
* `salt -L test,dvdlaivm02.ny3.corp.portware.net  pkg.list_pkgs -out=txt  | cut -c -20`
* `salt dvdlaivm02.ny3.corp.portware.net  pkg.install wget`
* `salt dvdlaivm02.ny3.corp.portware.net  sys.doc user | less -S`
* `salt dvdlaivm02.ny3.corp.portware.net  status.cpuinfo`
* `salt -L "$x"  --timeout 60 --state_output=mixed --state_verbose=false state.highstate saltenv=production`
* `salt '*' saltutil.refresh_pillar`
* `salt '*' cmd.run 'ls' cwd=/home`
* Show high state Data structure: `salt '*' state.show_sls base/motd`
* `salt '*' grains.ls`
* List all grains with not only key, but also value `salt 'dvdlaivm02*' grains.items`
* List all pillar with not only key, but also value `salt 'dvdlaivm02*' pillar.items`
* Querying one grain `salt '*' grains.get shell`
* `salt '*' grains.get os --output=txt | grep RedHat`
* Update file system
* `salt-run fileserver.update`
* `salt-run fileserver.update backend=roots,git`

Targetting
* `salt -C 'G@os:RedHat and G@osmajorrelease:6' test.ping --output=txt | sort`
* `salt -C 'G@os:RedHat and G@fqdn:dvdlai*' test.ping --output=txt | sort`
* `salt -C 'not G@domain:nj1.portware.net and not G@domain:il1.portware.net and not G@domain:ny3.corp.portware.net and not G@domain:in1.corp.portware.net and not G@domain:corp.portware.net and not    *G@domain:portware.com'  test.ping`
* `salt -C 'not P@linux_fdsinfo_prod_state:(dev|prod|stage|lab)' state.apply saltenv=production`
* `salt -G 'ipv4:10.162.100.100' test.ping`
* `salt -C 'not P@linux_fdsinfo_prod_state:(dev|prod|stage|lab)' state.apply saltenv=production`
* `salt -C 'not G@domain:(corp.portware.net|portware.com|nj1.portware.net|il1.portware.net|ny3.corp.portware.net|in1.corp.portware.net)' test.ping`
* `salt -C 'not G@domain:nj1.portware.net and not G@domain:il1.portware.net and not G@domain:ny3.corp.portware.net and not G@domain:in1.corp.portware.net and not G@domain:corp.portware.net'  test.ping`
* `salt -C 'G@fqdn:dvadigiliovm01.ny3.corp.portware.net or G@fqdn:dvaprishchevm01.ny3.corp.portware.net' test.ping --output=txt | sort`
* `salt -L 'dvadigiliovm01.ny3.corp.portware.net,dvaprishchevm01.ny3.corp.portware.net' test.ping --output=txt | sort`

Salt Reports
* `salt 'dvdlaivm02*' jobs.last_run`
* `salt-run jobs.last_run target='dvdlaivm02*' --output=json`
* `salt-run jobs.last_run target='dvdlaivm02*'`
* `salt-run jobs.lookup_jid 20170928163246803052`
* `salt-run jobs.lookup_jid 20170928163740927691 --output=txt`
* `salt-run jobs.list_jobs --output=json search_function='state.highstate' search_target='dvdlaivm02*'`
* `salt-run jobs.list_job --output=json "20171220164622111670"`

## Salt Window

Window Services

``` console
[root@ip-10-0-0-100 ~]# salt "EC2AMAZ-JL5QSVP.us-east-2.compute.internal" win_servermanager.list_available
EC2AMAZ-JL5QSVP.us-east-2.compute.internal:

    Display Name                                            Name
    ------------                                            ----
    [ ] Active Directory Certificate Services               AD-Certificate
        [ ] Certification Authority                         ADCS-Cert-Authority
        [ ] Certificate Enrollment Policy Web Service       ADCS-Enroll-Web-Pol
        [ ] Certificate Enrollment Web Service              ADCS-Enroll-Web-Svc
        [ ] Certification Authority Web Enrollment          ADCS-Web-Enrollment
        [ ] Network Device Enrollment Service               ADCS-Device-Enrollment
        [ ] Online Responder                                ADCS-Online-Cert
    [ ] Active Directory Domain Services                    AD-Domain-Services
    [ ] Active Directory Federation Services                ADFS-Federation
    [ ] Active Directory Lightweight Directory Services     ADLDS
    [ ] Active Directory Rights Management Services         ADRMS
        [ ] Active Directory Rights Management Server       ADRMS-Server
        [ ] Identity Federation Support                     ADRMS-Identity
    [ ] Device Health Attestation                           DeviceHealthAttestat...
    [ ] DHCP Server                                         DHCP
    [ ] DNS Server                                          DNS
    [ ] Fax Server                                          Fax
    [X] File and Storage Services                           FileAndStorage-Services
        [ ] File and iSCSI Services                         File-Services
            [ ] File Server                                 FS-FileServer
            [ ] BranchCache for Network Files               FS-BranchCache
            [ ] Data Deduplication                          FS-Data-Deduplication
            [ ] DFS Namespaces                              FS-DFS-Namespace
            [ ] DFS Replication                             FS-DFS-Replication
            [ ] File Server Resource Manager                FS-Resource-Manager
            [ ] File Server VSS Agent Service               FS-VSS-Agent
```

``` console
[root@ip-10-0-0-100 ~]# salt "EC2AMAZ-JL5QSVP.us-east-2.compute.internal" win_servermanager.remove AD-Domain-Services
EC2AMAZ-JL5QSVP.us-east-2.compute.internal:
    ----------
    DisplayName:
        AD-Domain-Services (not installed)
    ExitCode:
        1003
    RestartNeeded:
        False
    Success:
        True
```

``` console
salt "EC2AMAZ-JL5QSVP.us-east-2.compute.internal" win_servermanager.install AD-Domain-Services
```