# Puppet for LDN

## Summary

* this repository should contain the public stuff;

* `Puppetfile` list of external modules to load in `modules/`;

* `modules/` contains the modules declared by `Puppetfile` and managed
  by `r10k`,

  * `modules/ldn` contains the private stuff (ideally it should be hiera files
    only);

* `modules-ldn/` contains some modules local to this repository.

## Installation

### Prerequists

* ssh (client)

* git

* Puppet stuff: puppet (3.7), hiera, r10k

### Installing puppet with bundler

You might want to install puppet using bundler in order to have the correct
version (especially if your distribution does not ship the correct version):

    apt install bundler
    bundle install

The local ruby/puppet commands must be executed with `bundle exec`:

    bundle exec r10k puppetfile install Puppetfile

### SSH

This documentation assumes that your ~/.ssh/config is configured in order to
access to the servers with `ssh $home.newldn` and the GIT repositories with
`ssh gitldn`.

## Basic usage

Clone the repository:

    git clone gitldn:puppet/puppet

Install the modules:

    r10k puppetfile install Puppetfile

Update the puppet from the repository and apply:

    # Update the puppet master from the git repo:
    ssh zoidberg.newldn sudo /root/update.sh
    
    # Apply the rules from the puppet master on some server:
    ssh foo.newldn sudo puppet agent -t

## Development

Don't forget to install the modules:

    r10k puppetfile install Puppetfile

Upload the current directory as as `test` environment on the Puppet master:

    ./scripts/upload-env test

Apply the `test` environment on some server:

    ssh foo.newldn sudo puppet agent -t --environment=test

Commit and push our modifications:

    git commit -am"[vpn] Do something on the VPN"
    git push origin HEAD
