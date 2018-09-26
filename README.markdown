# duo

master branch: [![Build Status](https://secure.travis-ci.org/millerjl1701/millerjl1701-duo.png?branch=master)](http://travis-ci.org/millerjl1701/millerjl1701-duo)

#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
1. [Setup - The basics of getting started with duo](#setup)
    * [What duo affects](#what-duo-affects)
    * [Beginning with duo](#beginning-with-duo)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Module Description

This module provides for installation and configuration of the Duo Unix Two-Factor Authentication for SSH application using a minimalist configuration style for Puppet 4 and 5. If you are not a current customer of Duo, this module will not be very useful.

One also needs to configure ssh and/or pam in addition to duo. However, this module makes no attempt to manage either of those application requirements in order to allow for flexibility. If you are looking for modules that might be useful for ssh or pam, there are many on the Puppet forge. The module's primary author uses:

* [saz/ssh](https://forge.puppet.com/saz/ssh) module
* [ghoneycutt/pam](https://forge.puppet.com/ghoneycutt/pam) module

However, nothing precludes you from using a different module for either component. 

For documentation concerning the product and use of Duo, please refer to the Duo web site: [https://duo.com/](https://duo.com/) For support concerning the Duo application itself, please contact Duo directly [https://duo.com/](https://duo.com/) as I will be unable to assist you in issues with the application. For Puppet 3 support, I strongly recommend the use of [Duo's puppet module](https://forge.puppet.com/duosecurity/duo_unix) which was archived on 2/2/2018.

## Setup

### What duo affects

* File: /etc/duo/login_duo.conf
* File: /etc/duo/pam_duo.conf
* File: /etc/yum.repos.d/duosecurity (management can be disabled)
* Package: openssl-devel, zlib-devel (management can be disabled)
* Package: duo_unix

### Beginning with duo

```puppet
class { 'duo':
  config_ikey    => 'ikeystringfromduo',
  config_skey    => 'skeystringfromduo',
  config_apihost => 'f.q.d.n',
}
```

should be all that is needed to install and configure the duo_unix application to the application defaults and recommended configuration using pam_duo. The required paremeters are determined from your particular Duo itegration. Since they are specific to each use case, they are required parameters without any defaults given. If you do not include them in you class statement, puppet will error out.

## Usage

All parameters to the main class may be passed in via puppet code or hiera.

### Install duo_unix and configure to use pam_login with defaults

```puppet
class { 'duo':
  config_ikey    => 'ikeystringfromduo',
  config_skey    => 'skeystringfromduo',
  config_apihost => 'f.q.d.n',
}
```

### Install duo_unix using a local mirror of the Duo repository

```puppet
class { 'duo':
  config_ikey  => 'ikeystringfromduo',
  config_skey  => 'skeystringfromduo',
  repo_baseurl => 'http://foo.example.com/bar',
}
```

### Install duo_unix using a package manager like Spacewalk

```puppet
class { 'duo':
  config_ikey  => 'ikeystringfromduo',
  config_skey  => 'skeystringfromduo',
  manage_repo  => false,
}
```


### Install duo_unix and configure to use login_duo with defaults

```puppet
class { 'duo':
  config_ikey       => 'ikeystringfromduo',
  config_skey       => 'skeystringfromduo',
  config_apihost    => 'f.q.d.n',
  config_login_type => 'login',
}
```

### Install duo_unix and configure the application to use a http proxy

```puppet
class { 'duo':
  config_ikey       => 'ikeystringfromduo',
  config_skey       => 'skeystringfromduo',
  config_apihost    => 'f.q.d.n',
  config_http_proxy => 'http://myproxy.example.com:8080/',
}
```

## Reference

Generated puppet strings documentation with examples is available from [https://millerjl1701.github.io/millerjl1701-duo](https://millerjl1701.github.io/millerjl1701-duo).

The puppet strings documentation is also included in the /docs folder.

## Limitations

This module was created using CentOS/RHEL 7 for Puppet 4.7+ and Puppet 5 clients. In time, other operating systems will be added such as Ubuntu. Parameters were added to allow for configuration according to the Duo documentation. The most tested case is the login_duo configuration by the author. There is limited configuration checking for the parameters passed to the class.

For the Duo application to properly work, ssh and/or pam need to be configured according to the Duo documentation [https://duo.com/docs/duounix](https://duo.com/docs/duounix). This module does not configure either of those components, and duo will not function properly until you do so. Please refer to the Duo documentation for how to test your configuration.

## Development

Please see the [CONTRIBUTING document](CONTRIBUTING.md) for information on how to get started developing code and submit a pull request for this module. While written in an opinionated fashion at the start, over time this can become less and less the case.

### Contributors

To see who is involved with this module, see the [GitHub list of contributors](https://github.com/millerjl1701/millerjl1701-duo/graphs/contributors) or the [CONTRIBUTORS document](CONTRIBUTORS).
