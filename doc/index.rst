.. Swedish Embedded Workstation documentation, Martin Schröder

Swedish Embedded Workstation
============================

.. toctree::
   :maxdepth: 2
   :caption: Contents:

- Git repository: https://github.com/swedishembedded/workstation
- Community: https://swedishembedded.com/community

Introduction
============

This is a development docker image for building embedded systems using Zephyr RTOS and Swedish
Embedded Platform SDK.

.. figure:: images/demo.gif

    Demo of developer image]

.. figure:: images/windows-demo.jpg

    Windows WSL Development

The project uses a **single consolidated multi-stage Dockerfile** that produces five different images:

- **boot**: Base OS with locales, build essentials, Python venv, and non-root user
- **dev**: Development tools, Node.js, Docker CLI, editors, and debugging tools
- **rust**: Rust toolchain with cross-compilation targets
- **zephyr**: Zephyr RTOS CI/build environment with SDK, toolchains, and documentation tools
- **workstation**: Full developer workstation with UX tools, LSPs, and configurations

.. uml::

    @startditaa

    +-------------+
    | workstation |
    +-------------+
           ^
           |
    +-------------+
    |   zephyr    |
    +-------------+
           ^
           |
    +-------------+
    |    rust     |
    +-------------+
           ^
           |
    +-------------+
    |     dev     |
    +-------------+
           ^
           |
    +-------------+
    |    boot     |
    +-------------+

    @endditaa

Architecture
------------

The build system uses Docker BuildKit multi-stage builds with build-only stages for heavy toolchains
(Zephyr SDK, BSIM, OSS CAD Suite, Neovim, Ledger) to optimize layer caching and reduce rebuild times.
Build artifacts are copied into final images, keeping build dependencies out of the final layers.

**Supported Platforms:**

- ``linux/amd64`` (x86_64) - Full support including x86-only tools (Doxygen, NRF tools)
- ``linux/arm64`` (aarch64) - Most tools supported, some x86-only tools excluded

**Supported Ubuntu Versions:**

- ``Ubuntu 24.04 LTS`` - Long-term support release (recommended for production)
- ``Ubuntu 25.04`` - Latest release with newer packages

Images are tagged with Ubuntu version using semantic versioning build metadata:

- ``swedishembedded/workstation:latest-ubuntu24.04``
- ``swedishembedded/workstation:0.26.6-1+ubuntu24.04``
- ``swedishembedded/workstation:ubuntu25.04``

**Build System:**

- Single ``Dockerfile`` with named stages
- ``docker-bake.hcl`` for parallel BuildKit builds
- ``Makefile`` with individual and parallel build targets
- Multi-version Ubuntu support with automatic semantic versioning

Using Pre-built Images
======================

Pull the latest prebuilt docker images:

.. code-block:: sh

    # Full developer workstation (Ubuntu 25.04)
    docker pull swedishembedded/workstation:latest
    
    # Or specific Ubuntu version
    docker pull swedishembedded/workstation:ubuntu24.04  # Ubuntu 24.04 LTS
    docker pull swedishembedded/workstation:ubuntu25.04  # Ubuntu 25.04
    
    # Or specific versioned image
    docker pull swedishembedded/workstation:0.26.6-1+ubuntu24.04
    
    # Other images also available per Ubuntu version
    docker pull swedishembedded/boot:ubuntu24.04
    docker pull swedishembedded/dev:ubuntu24.04
    docker pull swedishembedded/rust:ubuntu24.04
    docker pull swedishembedded/zephyr:ubuntu24.04

Running the Workstation
------------------------

Run with your workspace mounted:

.. code-block:: sh

    docker run -ti -v $myworkspace:/workspaces \
           swedishembedded/workstation:latest

The command above mounts your workspace under ``/workspaces`` inside the image so you can
work on your local files from within the image.

Hardware Access (USB JTAG)
---------------------------

To flash firmware over USB JTAG, run docker in privileged mode and mount USB:

.. code-block:: sh

    docker run -ti -v $myworkspace:/workspaces \
        --privileged -v /dev/bus/usb:/dev/bus/usb \
        swedishembedded/workstation:latest

This allows you to access JTAG adapters from inside the container. You can
also expose other resources to the container in the same way.

Using Tmuxinator
----------------

Once inside the image, there is a workspace tool installed called tmuxinator
which is bound to alias "workspace". You can open the demo workspace like this:

.. code-block:: sh

    workspace demo

Building Your Own Images
========================

Prerequisites
-------------

Docker with BuildKit support (Docker 19.03+ or buildx plugin):

.. code-block:: sh

    # Enable BuildKit (if not default)
    export DOCKER_BUILDKIT=1
    
    # Or install buildx
    docker buildx install

Build All Images in Parallel
-----------------------------

The fastest way to build all images is using ``docker buildx bake``:

.. code-block:: sh

    # Build all images in parallel (default Ubuntu 25.04)
    make bake
    
    # Build and push all images
    make bake/push
    
    # Build for multiple platforms
    make PLATFORMS=linux/amd64,linux/arm64 bake

Build for Specific Ubuntu Versions
-----------------------------------

Build images for specific Ubuntu versions with proper semantic versioning:

.. code-block:: sh

    # Build all images for Ubuntu 24.04 LTS
    make bake/ubuntu24
    
    # Build all images for Ubuntu 25.04
    make bake/ubuntu25
    
    # Build for BOTH Ubuntu versions in parallel
    make bake/all-ubuntu
    
    # Build and push Ubuntu 24.04 images
    make bake/ubuntu24/push
    
    # Build and push both Ubuntu versions
    make bake/all-ubuntu/push
    
    # Check current version
    make version
    # Output:
    # Current version: 0.26.6-1
    # Ubuntu 24.04: 0.26.6-1+ubuntu24.04
    # Ubuntu 25.04: 0.26.6-1+ubuntu25.04

Build Individual Images
-----------------------

Build a specific image:

.. code-block:: sh

    # Build individual images
    make boot
    make dev
    make rust
    make zephyr
    make workstation
    
    # Build without cache
    make boot/nocache
    
    # Push to registry
    make boot/push

Build Sequentially
------------------

Build all images sequentially (slower but simpler):

.. code-block:: sh

    make all

Multi-Platform Builds
---------------------

Build for multiple platforms using buildx:

.. code-block:: sh

    # Build and push for multiple platforms
    make buildx/workstation/push PLATFORMS=linux/amd64,linux/arm64

Configuration Options
---------------------

Customize builds with environment variables:

.. code-block:: sh

    # Change registry
    make bake IMG_NS=myregistry
    
    # Change platforms
    make bake PLATFORMS=linux/amd64,linux/arm64
    
    # Use different Docker command
    make bake DOCKER=podman

What is included
================

The following sections describe in more detail what is included into each image. This list may not
be fully up to date so please check the individual dockerfiles for up to date list of packages.

Base Image (Zephyr)
-------------------

This is the absolute minimum base image on which all other images are built. It starts with a Ubuntu
base image and installs the following tools:

.. list-table::
   :header-rows: 1
   :widths: 20 50

   * - Category
     - Packages
   * - General Dependencies
     - | software-properties-common
       | lsb-release
       | autoconf
       | automake
       | bison
       | build-essential
       | ca-certificates
       | ccache
       | chrpath
       | cpio
       | device-tree-compiler
       | dfu-util
       | diffstat
       | dos2unix
       | doxygen
       | file
       | flex
       | g++
       | gawk
       | gcc
       | gcovr
       | git
       | git-core
       | gnupg
       | gperf
       | gtk-sharp2
       | help2man
       | iproute2
       | lcov
       | libglib2.0-dev
       | libgtk2.0-0
       | liblocale-gettext-perl
       | libncurses5-dev
       | libpcap-dev
       | libpopt0
       | libsdl1.2-dev
       | libsdl2-dev
       | libssl-dev
       | libtool
       | libtool-bin
       | locales
       | make
       | net-tools
       | ninja-build
       | openssh-client
       | pkg-config
       | python3-dev
       | python3-pip
       | python3-ply
       | python3-setuptools
       | python-is-python3
       | qemu
       | rsync
       | socat
       | srecord
       | sudo
       | texinfo
       | unzip
       | valgrind
       | wget
       | ovmf
       | xz-utils
   * - Multi-lib gcc (x86 only)
     - gcc-multilib, g++-multilib
   * - i386 packages (x86 only)
     - libsdl2-dev:i386
   * - System Locale
     - en_US.UTF-8
   * - CMake
     - cmake
   * - Python Dependencies
     - | wheel
       | pip
       | west
       | sh
       | awscli
       | PyGithub
       | junitparser
       | pylint
       | statistics
       | numpy
       | imgtool
       | protobuf
       | GitPython

Base CI Image (Zephyr)
----------------------

This image comes from zephyr and includes the basic set of tools to run Zephyr based CI jobs.

It includes the following:

.. list-table::
   :header-rows: 1
   :widths: 20 50

   * - Category
     - Packages
   * - Doxygen (x86 only)
     - doxygen
   * - Renode (x86 only)
     - renode
   * - BSIM
     - BabbleSim
   * - uefi-run Utility
     - Rust, uefi-run
   * - LLVM and Clang
     - | llvm
       | clang
   * - Protobuf-compiler
     - protoc
   * - Zephyr SDK
     - zephyr-sdk

Build Image
-----------

This image extends Zephyr CI image and is intended as the main CI build image for applications using
Swedish Embedded Platform SDK. It includes the following packages:

.. list-table::
   :header-rows: 1
   :widths: 20 50

   * - Category
     - Packages
   * - Basic System Utilities
     - | bc
       | curl
   * - Python Packages
     - | cmakelang
       | click
       | black (22.3.0)
       | robotframework (4.0.1)
   * - Documentation Generation
     - | doxygen-latex
       | dot2tex
       | librsvg2-bin
       | texlive-latex-base
       | texlive-latex-extra
       | latexmk
       | texlive-fonts-recommended
       | ruby
       | bundler
       | aspell
       | aspell-en
       | asciidoctor-pdf (Ruby gem)
       | asciidoctor-html5s (Ruby gem)
   * - JavaScript and Node.js
     - nodejs, npm
   * - Ruby Packages for CMock
     - bundler, rake, manifest, require_all, constructor, diy
   * - Code Checking
     - | clang-format
       | libclang-12-dev
       | clang (12.0.1)
       | cscope
   * - Image Testing
     - imagemagick
   * - Other
     - git-lfs, octave
   * - PCB Design
     - Kicad, kibot (Python package)
   * - OSS CAD Suite
     - oss-cad-suite-linux-x64-20221105 (full suite for building Verilog stuff)

Developer Image
---------------

This image builds further on the "build" image and also includes the following packages:

.. list-table::
   :header-rows: 1
   :widths: 20 40

   * - Category
     - Packages
   * - Additional Development Tools
     - | cmake
       | ncurses-dev
       | libgccjit0
       | libgccjit-10-dev
       | libjansson4
       | libjansson-dev
       | gnutls-dev
   * - Text Editors
     - | emacs (version 28.1)
       | vim
       | nano
   * - Terminal Utilities
     - | tmux
       | tree
       | picocom
   * - Debugging Tools
     - gdb-multiarch
   * - Emacs Configuration
     - DooM emacs
   * - Tmux Configuration
     - tmuxinator
   * - Other
     - | ripgrep (search tool)
       | wget
       | renode-run
       | dos2unix

Cleanup
=======

If you find that your system runs out of space then you can always delete all
modified docker data by pruning everything (be careful because this will delete
any changes you have done to files inside a docker container. It will **not**
however remove files you modified in a mounted local directory. So it's safe.):

.. code-block:: sh

    docker system prune --volumes

Questions
=========

Why is the docker image so big?
-------------------------------

Because it includes **all essential tools** including a handful of different
compilers which are used for cross compiling, source code and git repositories
used for demo. Every tool included in the base image is useful at some stage in
the build process. The build image is designed to be a versatile build image
that can be used to build not just firmware but multiple types of documentation
as well.

Is it possible to reduce the size?
----------------------------------

You can probably reduce the size but it is not practical because you will always
run into cases where you need extra tools and you will find that you
will need to add them back again. It is better to have a single image that
contains a complete and reproducible invironment so that it is possible to
easily scale development to multiple projects.


Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
