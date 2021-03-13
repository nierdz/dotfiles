[![CI Status](https://github.com/nierdz/tools/workflows/CI/badge.svg?branch=master)](https://github.com/nierdz/tools/actions?query=workflow%3ACI)

# Setup my laptop

### Requirements

 - First you nedd to be sudoers so you have ton install `sudo` package:

 ```
 #  apt install sudo
 ```

 - Then, add this line to `/etc/sudoers` or in a file inside `/etc/sudoers.d/`:
```
user	ALL = NOPASSWD:ALL
```

 - Finally, you can install everything in one simple target:

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
