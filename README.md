# Swedish Embedded Workstation

This is a complete embedded firmware development workstation based on Linux.

![Demo of developer image](doc/images/demo.gif)

- **Base Image (_ci-base_):** contains only the minimal set of software needed for basic development without the toolchains.
- **CI Image (_ci_):** contains toolchains, the zephyr sdk and additional packages needed for ci operations.
- **Developer Image (_zephyr-build_):** includes additional tools that can be useful for Zephyr
  development.
- Workstation: a fully integrated development environment with tools for
  building additional documentation, emacs, vim etc.
  
See [Documentation](doc/index.rst) for more detailed documentation.

It includes:

- Zephyr RTOS base tools included as official Zephyr RTOS docker image
- Docker images: 2 main docker images for CI builds and develop builds.
- Local bootstrapping scripts
- Tmux configuration
- i3wm configuration
- Vim configuration (see [Awesome Vim](https://swedishembedded.com/insights-vim-in-minutes/) article)

## Quick Start

```
docker pull swedishembedded/build:latest
```

## Contact

- Community: https://swedishembedded.com/community

```
docker run -ti -v $HOME/Work/zephyrproject:/workdir \
           docker.io/zephyrprojectrtos/zephyr-build:latest
```

#### Building Developer Docker Image

The developer docker image can be built using the following command:

```
docker build -f Dockerfile.devel --build-arg UID=$(id -u) --build-arg GID=$(id -g) -t zephyr-build:v<tag> .
```

It can be used for building Zephyr samples and tests by mounting the Zephyr workspace into it:

```
docker run -ti -v <path to zephyr workspace>:/workdir zephyr-build:v<tag>
```

### Usage

#### Building a sample application

Follow the steps below to build and run a sample application:

```
west build -b qemu_x86 samples/hello_world
west build -t run
```

#### Building display sample applications

It is possible to build and run the _native POSIX_ sample applications that produce display outputs
by connecting to the Docker instance using a VNC client.

In order to allow the VNC client to connect to the Docker instance, the port 5900 needs to be
forwarded to the host:

```
docker run -ti -p 5900:5900 -v <path to zephyr workspace>:/workdir zephyr-build:v<tag>
```

Follow the steps below to build a display sample application for the _native POSIX_ board:

```
west build -b native_posix samples/subsys/display/cfb
west build -t run
```

The application display output can be observed by connecting a VNC client to _localhost_ at the
port _5900_. The default VNC password is _zephyr_.

On a Ubuntu host, this can be done by running the following command:

```
vncviewer localhost:5900
```
