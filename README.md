# Puppet for LDN

## Summary

* this repository should contain the public stuff;

* `Puppetfile` list of external modules to load in `modules/`;

* `modules/` contains the modules decmlared by `Puppetfile` and managed
  by `r10k`;

  * `modules/ldn` contains the private stuff (ideally it should be hiera files
    only),

## Basic usage

This documentation assumes that your ~/.ssh/config is configured in order to
access to the servers with `ssh $home.newldn` and the GIT repositories with
`ssh gitldn`.

Clone the repository:

    git clone gitldn:puppet/puppet

Install the modules:

    r10k puppetfile install Puppetfile

Commit and push:

    git commit -am"[vpn] Do something on the VPN"
    git push origin HEAD

Update the puppet from the repository and apply:

    # Update the puppet master from the git repo:
    ssh zoidberg.newldn sudo /root/update.sh
    
    # Apply the rules from the puppet master on some server:
    ssh foo.newldn sudo puppet agent -t
