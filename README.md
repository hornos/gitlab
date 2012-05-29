# Gitlab w/ Chef & Vagrant

## Prerequisites

1. Install [Virtual Box](https://www.virtualbox.org). Downloads can be found [here](https://www.virtualbox.org/wiki/Downloads)
2. Install [Vagrant](http://vagrantup.com) by either running `gem install vagrant` or by [downloading](http://downloads.vagrantup.com/) and running the appropiate installer for your operating system

If you have problems installing or running vagrant you should consult the [official documentation](http://vagrantup.com/v1/docs/index.html).

Get the 'Lucid 32' box (it should work on others, but only tested with
lucid)

## Usage

    vagrant box add precise32 http://files.vagrantup.com/precise32.box

Clone repository

    git clone git://github.com/oschrenk/gitlab.git
    cd gitlab

Init and update the submodules

    git submodule init
    git submodule update

Start up vagrant
  
    vagrant up

Connect to vagrant machine and start rails process

    vagrant ssh

    cd /vagrant/gitlabhq
    bundle exec thin start -e production

On your local machine, update /etc/hosts and add:

    33.33.33.20 gitlab.local

Connect to the site

    http://gitlab.local

Login with:

    Email:    admin@local.host
    Password: 5iveL!fe
  
