Pillar Encrpte data
  http://www.clausconrad.com/blog/using-the-gpg-renderer-to-protect-salt-pillar-items
  http://aplawrence.com/Basics/gpg.html

gpg --gen-key --homedir /home/dlai/keys
  [dlai@dvdlaivm02 15:22:11]:~> find keys
  keys
  keys/random_seed
  keys/pubring.gpg~
  keys/secring.gpg
  keys/trustdb.gpg
  keys/pubring.gpg
  [dlai@dvdlaivm02 15:22:14]:~>

gpg --homedir /home/dlai/keys --export-secret-keys --armor > /home/dlai/salt-master.key

gpg --homedir /home/dlai/keys --export --armor > /home/dlai/salt-master.pub

echo -n "thepassword" | gpg --homedir /home/dlai/keys --armor --encrypt -r dlaitest
  [dlai@dvdlaivm02 15:23:41]:~> echo -n "thepassword" | gpg --homedir /home/dlai/keys --armor --encrypt -r dlaitest
  -----BEGIN PGP MESSAGE-----
  Version: GnuPG v2.0.14 (GNU/Linux)

  hQEMA6RH+HpoRGEJAQf8DTANVoPCxLSrFntvWWr0G8xjH1LciCivDpTmdfQC9Bga
  iEQB99x8ZXHka9mkLzLQDHEUs92HFH+E4p95Egi01nEG5LPDqdwUttYBniC3yVyJ
  SAxbrFmW9TNACW6oy8VpN16y98/4Qa1r0knetEpA9Fc8ZqqWarxHwwEgtk8SqRmq
  wh48dz3rRx6GnGHhrenl52N9NABRFSbnF0j+e3wVRtRac/V8+mEWH9m2yam23kUO
  G/Rsril8SNpcCqI6afqWU+UWBEw+yG/PLj7sAJzgMrtnUT86RxuUsU7Q+nw0pZfR
  QXVzp9UhMV7MrZFZzNJFpqVVKryZ1cX2PFL02LoCe9JGAcY71kuO7u+DQHBS+Jsw
  jep5urmyxOYDsR2hfTDYIyU73EHmngEr2SGa2lkViuEbJre4L6eM335QXjcN50Or
  AA5cITQWfg==
  =vOHP
  -----END PGP MESSAGE-----
  [dlai@dvdlaivm02 15:23:43]:~>



~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Output:

[root@dvdlaivm05 salt]# salt '*' pillar.items
dvdlaivm05.ny3.corp.portware.net:
    ----------
    common:
        ----------
        user_admin:
            ----------
            password:
                $1$cldygdbe$eKvJDAGsl8psOmtYs0cNi.
            username:
                root
    dlaipass:
        ----------
        pass:
            -----BEGIN PGP MESSAGE-----
            Version: GnuPG v2.0.14 (GNU/Linux)

            hQEMA6RH+HpoRGEJAQf8DTANVoPCxLSrFntvWWr0G8xjH1LciCivDpTmdfQC9Bga
            iEQB99x8ZXHka9mkLzLQDHEUs92HFH+E4p95Egi01nEG5LPDqdwUttYBniC3yVyJ
            SAxbrFmW9TNACW6oy8VpN16y98/4Qa1r0knetEpA9Fc8ZqqWarxHwwEgtk8SqRmq
            wh48dz3rRx6GnGHhrenl52N9NABRFSbnF0j+e3wVRtRac/V8+mEWH9m2yam23kUO
            G/Rsril8SNpcCqI6afqWU+UWBEw+yG/PLj7sAJzgMrtnUT86RxuUsU7Q+nw0pZfR
            QXVzp9UhMV7MrZFZzNJFpqVVKryZ1cX2PFL02LoCe9JGAcY71kuO7u+DQHBS+Jsw
            jep5urmyxOYDsR2hfTDYIyU73EHmngEr2SGa2lkViuEbJre4L6eM335QXjcN50Or
            AA5cITQWfg==
            =vOHP
            -----END PGP MESSAGE-----
    puppet:
        ----------
        scheduled_puppet_sync:
            ----------
            puppet_noop:
                False
            puppet_sync_splay:
                True
            puppet_sync_time:
                5:15pm
    roles:
        - salt-master
    salt-master:
        ----------
        config:
            ----------






[root@dvdlaivm05 salt]# salt '*' pillar.items
dvdlaivm05.ny3.corp.portware.net:
    ----------
    common:
        ----------
        user_admin:
            ----------
            password:
                $1$cldygdbe$eKvJDAGsl8psOmtYs0cNi.
            username:
                root
    dlaipass:
        ----------
        pass:
            thepassword
    puppet:
        ----------
        scheduled_puppet_sync:
            ----------
            puppet_noop:
                False
            puppet_sync_splay:
                True
            puppet_sync_time:
                5:15pm
    roles:
        - salt-master
    salt-master:
        ----------
        config:
            ----------
