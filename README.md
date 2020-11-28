[![Build Status](https://github.com/nierdz/infra-docker/workflows/CI/badge.svg?branch=master)](https://github.com/nierdz/tools/actions?query=workflow%3ACI)

# Install & configure my laptop

 - it uses ansible in a virtualenv to deploy everythings
 - vim with vundle plugins
 - a bunch of binaries like docker-compose, docker, kubectl, kustomize, packer, terraform
 - a bunch of useful packages
 - install and configure starship to customize `$PS1`
 - use base16 for vim and terminator
 - install php and composer
 - customize bash to my taste

# Requirements

 - You need to be sudoers before running this **playbook**. To do so, just add this line to `/etc/sudoers` or in a file inside `/etc/sudoers.d/`:
```
user	ALL = NOPASSWD:ALL
```

 - Then, you can install dependencies:
```
make pre-install
```

# Usage

 - Use `install` target to install everything:
```
make install
```

 - If you just need to run ansible, use:
```
make run-ansible
```
