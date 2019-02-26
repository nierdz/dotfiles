[![Build Status](https://travis-ci.com/nierdz/tools.svg?branch=master)](https://travis-ci.com/nierdz/tools)

# My personal tools
 - It uses ansible in a virtualenv to deploy my personal tools:
  - vim with vundle plugins
  - [bash-git-prompt](https://github.com/magicmonty/bash-git-prompt)
  - a bunch of binaries like docker-compose, helm, stern, etc.
  - a bunch of useful packages

# Requirements
 - You need to be sudoers to use this `Makefile`
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
 - If you don't want to install everything, you can run a specific target:
```
make run-ansible
```
 - To get all targets from `Makefile`, use `help`:
```
make help
```
