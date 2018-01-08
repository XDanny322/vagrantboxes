# vagrantboxes
This repo contains bunch of my person testing vagrant boxes, separated by folders.  I use the repo to house all the Vagrantfiles for system i have built to test.

To use this repo, usually on your laptop

## Windows
* Install Choco - https://chocolatey.org/install
* Optional
  * `chovo install cygwin`
  * `chovo install cyg-get`
    * `cyg-get vim`
    * `cyg-get openssh`
    * `cyg-get sshd`
    * `cyg-get vim`
* `choco install vagrant`
* `choco install virtualbox`
* `git clone git@github.com:XDanny322/vagrantboxes.git`
* `vagrant up`

## Mac
* Coming soon

## Notes
Vagrant Commands
  ```
  vagrant -v
  vagrant suspend
  vagrant resume
  vagrant init hashicorp/precise32
  vagrant init centos/7
  vagrant ssh-config
  vagrant up
  vagrant ssh
  vagrant halt
  vagrant destory
  VBoxManage.exe -v
  VBoxManage.exe list vms
  ```

Sometimes vagrant ssh (2.0.1) doesn't work in Window's Cygwin. Do the below to get around.
  * To Fix: `export VAGRANT_PREFER_SYSTEM_BIN=1 `
     * See https://github.com/hashicorp/vagrant/issues/9143#issuecomment-343311263
  * To use TCP Networking:
    * `chmod 700 ./.vagrant/machines/default/virtualbox/private_key`
    * `ssh -i .vagrant/machines/default/virtualbox/private_key -p 2222 vagrant@localhost`