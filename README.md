[![CI Status](https://github.com/nierdz/tools/workflows/CI/badge.svg?branch=master)](https://github.com/nierdz/tools/actions?query=workflow%3ACI)

# Setup my laptop

### Requirements

 - If on Debian, install `sudo` package and add this to a file inside `/etc/sudoers.d/`:

```
#  apt install sudo
```

```
user	ALL = NOPASSWD:ALL
```

 - If on macOS, install [Homebrew](https://brew.sh/)

 - Then, install everything in one simple target:

```
make install
```

### Usage

 - Use `install` target to install everything:
```
make install
```

 - If you just need to run ansible, use:
```
make ansible-run
```
