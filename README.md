# mcollective

AtlasIT-AM/eyp-mcollective: [![Build Status](https://travis-ci.org/AtlasIT-AM/eyp-mcollective.png?branch=master)](https://travis-ci.org/AtlasIT-AM/eyp-mcollective)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What mcollective affects](#what-mcollective-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with mcollective](#beginning-with-mcollective)
4. [Usage](#usage)
5. [Reference](#reference)
5. [Limitations](#limitations)

## Overview

Setups mcollective agent and client

## Module Description

This module can manage the following mcollective components:
* activemq
* mcollective agent (daemon)
* mcollective client (mco)

## Setup

### What mcollective affects

#### activemq
* Everything under /etc/activemq

#### mcollective agent
* Everything under /etc/mcollective
* Installs mcollective plugins on it's libdir

#### mcollecitve client
* Everything under /etc/mcollective
* Installs mcollective plugins on it's libdir

### Setup Requirements **OPTIONAL**

This module requires pluginsync enabled

### Beginning with mcollective

mcollective agent:

```yaml
classes:
  - mcollecitve
mcollective::password: somepassword
mcollective::hostname: puppet
mcollective::psk: somepsk
mcollective::plugins_packages_ensure: installed
```

mcollective client and activemq daemon:

```yaml
classes:
  - mcollective
  - mcollective::activemq
mcollective::activemq::adminpw: adminpassword
mcollective::activemq::userpw: somepassword
mcollective::client: true
mcollective::password: somepassword
mcollective::hostname: puppet
mcollective::psk: somepsk
mcollective::plugins_packages_ensure: installed
```

## Usage

### mcollective
* *mcollective::hostname*: activemq hostname
* *mcollective::username*: activemq username (default: mcollective)
* *mcollective::password*: activemq password
* *mcollective::psk*: preshared key
* *mcollective::plugins_packages_ensure*: plugins status (default: present)
* *mcollective::plugins_packages*: plugins to be installed (default: package, service, puppet)
* *mcollective::agent*: install agent (default: true)
* *mcollective::client*: install client (default: false)

### mcollective::activemq

* *mcollective::activemq::adminpw*: activemq's admin password
* *mcollective::activemq::username*: activemq user (default: mcollective)
* *mcollective::activemq::userpw*: password for *mcollective::activemq::username*

## Reference

ActiveMQ on CentOS 6: http://systemadmin.es/2015/06/instalar-mcollective-con-activemq-en-centos-6

## Limitations

Tested on:
* CentOS 6
* Ubuntu 14.04
