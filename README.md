# ezscp
Easy secure copy

## Installation

Requires:

- scp

- bash

- sudo permissions

For install script:

- gzip

Download:

```
$ git clone https://github.com/sam-irl/ezscp.git
$ cd ezscp
```

To get right to it:

```
$ chmod +x ./ezscp.sh
$ ./ezscp.sh
```

To install to your environment (to run as a command):

For the lazy:

```
$ chmod +x ./INSTALL.sh
$ ./INSTALL.sh
```

Step-by-step install:

```
$ chmod +x ./ezscp
$ sudo mv ezscp /usr/bin
# Optional: to install the manpage
$ gzip ezscp.1
$ sudo mv ezscp.1.gz /usr/share/man/man1
# Run!
$ ezscp
```
