This Vagrant box was made a test system for Salt's State and Piller

In order to use the salt state from "work", on your local checkout, create a syslink to the real repos from "work"
* `ln -s /cygdrive/c/_AppLarge/_git/_fds_github/systems-infrastructure-automation/salt-state/ salt-state`
* `ln -s /cygdrive/c/_AppLarge/_git/_fds_github/systems-infrastructure-automation/salt-pillar/ salt-pillar`

To run high state, since iwe need the filesystem run it by:
`salt '*' state.highstate saltenv=base`
