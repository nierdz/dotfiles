[![Build Status](https://travis-ci.com/nierdz/tools.svg?branch=master)](https://travis-ci.com/nierdz/tools)

# My personal tools
 - It uses ansible in a virtualenv to deploy my personal tools
 - for now there is only some vim related stuffs
 - I'll update this soon to add my mess

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
 - First, you need to install ansible with:
```
make instal
```
 - Then you can run all ansible roles like this:
```
make run-ansible
```
