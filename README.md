# factorio

#### Table of Contents

1. [Overview](#overview)
3. [Setup - The basics of getting started with factorio](#setup)
    * [What factorio affects](#what-factorio-affects)
    * [Beginning with factorio](#beginning-with-factorio)
5. [Limitations - OS compatibility, etc.](#limitations)


## Overview

This module will install a Factorio headless server. 

## Setup

### What factorio affects

* Factorio user created
* Headless tarball downloaded and extracted
* New world created
* Systemd unit created, started, and enabled

### Beginning with factorio

Simply `include factorio` on the nodes and/or hierarchies you wish to have a server setup

The default world name will be generic. If you'd like to give your world a specific name, 
you can do so via hiera: 
`factorio::world_name: 'yourcustomworldname'`

## Generating a new world / Changing worlds

Follow the steps below to change to a different save game:
* Stop factorio (systemctl stop factorio)
* Update factorio::world_name with the changed/new name you wish to use
* Server will change maps and restart on next puppet run

## Limitations

To create a new world, you must stop the running server, then manually delete the existing save file. The next puppet run
will then setup a fresh world. 
