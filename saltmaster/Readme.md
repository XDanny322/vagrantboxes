This Vagrant box was made a test system for Salt's State and Piller

In order to use the salt state from "work", git clone the salt-pillar repo and salt-state repo onto the same dir as the Vagrant file.  There are git ignore that will prevent it from getting pushed up to git.

`git clone git@github.factset.com:systems-infrastructure-automation/salt-pillar.git`
`git clone git@github.factset.com:systems-infrastructure-automation/salt-state.git`

To run high state, since iwe need the filesystem run it by:
`salt '*' state.highstate saltenv=base`