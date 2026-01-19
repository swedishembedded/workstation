# ==============================================================================
# Swedish Embedded Workstation - Consolidated Multi-Stage Dockerfile
# ==============================================================================
# This Dockerfile consolidates boot, dev, rust, zephyr, and workstation images
# into a single multi-stage build for improved caching and maintainability.
#
# Exportable targets:
#   - boot:        Base OS with build essentials
#   - dev:         Development tools and editors
#   - rust:        Rust toolchain with cross-compilation targets
#   - zephyr:      Zephyr RTOS CI/build environment
#   - workstation: Full developer workstation with UX tools
#
# Build individual targets:
#   docker build --target boot -t swedishembedded/boot:latest .
#   docker build --target dev -t swedishembedded/dev:latest .
#
# Build all targets in parallel:
#   docker buildx bake -f docker-bake.hcl
# ==============================================================================

# ==============================================================================
# Build Arguments - Version Control
# ==============================================================================
ARG UBUNTU_VERSION=25.04
ARG NODE_VERSION=22
ARG ZSDK_VERSION=0.17.4
ARG LLVM_VERSION=20
ARG NEOVIM_VERSION=v0.11.4
ARG OSS_CAD_SUITE_VERSION=20240211
ARG DOXYGEN_VERSION=1.9.4
ARG RENODE_VERSION=1.15.3
ARG BSIM_VERSION=v2.1
ARG SPARSE_VERSION=9212270048c3bd23f56c20a83d4f89b870b2b26e
ARG PROTOC_VERSION=21.7

# User configuration
ARG UID=1000
ARG GID=1000

# Optional flags
ARG INSTALL_DOCKER_DAEMON=true
ARG WGET_ARGS="-q --show-progress --progress=bar:force:noscroll --no-check-certificate"

# ==============================================================================
# Stage: boot
# ==============================================================================
# Base OS with locales, build essentials, Python venv, and non-root user
# ==============================================================================
FROM ubuntu:${UBUNTU_VERSION} AS boot

ARG UID
ARG GID
ARG TARGETARCH

# Set default shell and non-interactive mode
SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive

# Install system essentials, locales, build tools, and Python in one layer
# This consolidates all base package installation for optimal caching
RUN apt-get -y update && \
    apt-get install --no-install-recommends -y \
    # Core system utilities
    apt-utils \
    ca-certificates \
    curl \
    gnupg \
    openssl \
    wget \
    locales \
    sudo \
    lsb-release \
    # Build essentials
    build-essential \
    cmake \
    gcc \
    g++ \
    make \
    ninja-build \
    # Python
    python3-dev \
    python3-pip \
    python3-setuptools \
    python3-venv \
    python3-pexpect \
    python-is-python3 \
    && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

# Configure locales
RUN locale-gen en_US.UTF-8 sv_SE.UTF-8 && \
    dpkg-reconfigure locales

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LC_CTYPE=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV KEYBOARD=sv

# Create non-root user with sudo privileges
RUN userdel ubuntu 2>/dev/null || true && \
    groupadd -g ${GID} -o user && \
    useradd -u ${UID} -m -g user -G sudo user && \
    echo 'user ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/user && \
    chmod 0440 /etc/sudoers.d/user

USER user
WORKDIR /home/user

# Create Python virtual environment
ENV VIRTUAL_ENV=/home/user/.venv
ENV PATH="${VIRTUAL_ENV}/bin:$PATH"

RUN python3 -m venv ${VIRTUAL_ENV} && \
    chown -R user:user ${VIRTUAL_ENV} && \
    python3 -m pip install -U --no-cache-dir pip && \
    pip3 install -U --no-cache-dir wheel setuptools && \
    pip3 check && \
    pip3 cache purge && \
    chown -R user:user ${VIRTUAL_ENV}

CMD ["/bin/bash"]

# ==============================================================================
# Stage: dev
# ==============================================================================
# Development tools: editors, Node.js, Docker CLI/engine, debugging tools
# ==============================================================================
FROM boot AS dev

ARG NODE_VERSION
ARG INSTALL_DOCKER_DAEMON
ARG TARGETARCH

USER root

# Install development packages and tools in consolidated layers
# Layer 1: Core development tools
RUN apt-get -y update && \
    apt-get install --no-install-recommends -y \
    # Shell and development utilities
    argon2 \
    bash-completion \
    bats \
    bc \
    btop \
    certbot \
    coreutils \
    debianutils \
    dnsutils \
    gettext \
    git-lfs \
    gitk \
    iputils-ping \
    kmod \
    less \
    nano \
    netcat-openbsd \
    net-tools \
    openssh-client \
    p7zip-full \
    parallel \
    picocom \
    plocate \
    pre-commit \
    pv \
    python3-certbot-dns-cloudflare \
    python3-certbot-dns-google \
    python3-certbot-dns-route53 \
    rename \
    ripgrep \
    rsync \
    shellcheck \
    socat \
    tig \
    tmux \
    tree \
    vim \
    xauth \
    xclip \
    xterm \
    xvfb \
    xxd \
    xz-utils \
    yamllint \
    lz4 \
    zstd \
    # Editors
    emacs \
    neovim \
    # Debuggers
    gdb-multiarch \
    valgrind \
    # Build and analysis tools
    asciidoc \
    autoconf \
    automake \
    binutils \
    bison \
    ccache \
    chrpath \
    clang-format \
    clangd \
    cpio \
    cscope \
    cvs \
    device-tree-compiler \
    dfu-util \
    diffstat \
    docbook-utils \
    dos2unix \
    doxygen \
    file \
    flex \
    gawk \
    gcovr \
    git-core \
    gperf \
    groff \
    help2man \
    host \
    iproute2 \
    jq \
    lcov \
    ledger \
    lzop \
    m4 \
    mercurial \
    mtd-utils \
    pkg-config \
    srecord \
    subversion \
    swig \
    texi2html \
    texinfo \
    thrift-compiler \
    tzdata \
    u-boot-tools \
    unzip \
    zip \
    # Libraries and development headers
    desktop-file-utils \
    gnutls-dev \
    libacl1-dev \
    libarchive-dev \
    libasound2-dev \
    libboost-date-time-dev \
    libboost-dev \
    libboost-filesystem-dev \
    libboost-iostreams-dev \
    libboost-python-dev \
    libboost-regex-dev \
    libboost-system-dev \
    libboost-test-dev \
    libcairo2-dev \
    libedit-dev \
    libelf-dev \
    libgbm-dev \
    libglib2.0-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libgmp3-dev \
    libgnutls28-dev \
    libgtk-3-0 \
    libgtk2.0-0 \
    libgtest-dev \
    libjansson-dev \
    libjansson4 \
    liblocale-gettext-perl \
    liblz-dev \
    liblzo2-2 \
    liblzo2-dev \
    libmpfr-dev \
    libnotify-dev \
    libnss3 \
    libpcap-dev \
    libpopt0 \
    libpython3-dev \
    libsdl1.2-dev \
    libsdl2-dev \
    libssl-dev \
    libtool \
    libtool-bin \
    libx11-dev \
    libxml2-utils \
    libxss1 \
    libxtst6 \
    luarocks \
    ncurses-dev \
    openbox \
    ovmf \
    python3-cryptography \
    python3-jsonschema \
    python3-ply \
    python3-pyelftools \
    python3-xdg \
    python3-yaml \
    python3-pygments \
    qemu-system \
    qemu-user-static \
    uuid \
    uuid-dev \
    x11proto-core-dev \
    xsltproc \
    zlib1g-dev \
    # Documentation tools
    biber \
    octave \
    && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

# Install version-specific development libraries (Ubuntu 24.04+)
# These packages are not available in Ubuntu 22.04
RUN apt-get -y update && \
    (apt-get install --no-install-recommends -y \
        libclang-19-dev \
        libgccjit-14-dev \
        libgccjit0 || \
        echo "Note: Some version-specific dev packages not available (expected on Ubuntu 22.04)") && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

# Install multi-lib gcc (x86_64 only)
# Note: i386 packages may have dependency issues on some Ubuntu versions
RUN if [ "$(uname -m)" = "x86_64" ]; then \
        apt-get -y update && \
        apt-get install --no-install-recommends -y \
            gcc-multilib \
            g++-multilib && \
        dpkg --add-architecture i386 && \
        apt-get -y update && \
        # Try to install i386 packages, but continue if they fail (non-critical)
        (apt-get install --no-install-recommends -y \
            libc6-dev-i386 \
            lib32ncurses5-dev \
            lib32z-dev \
            libsdl2-dev:i386 || \
            echo "Warning: Could not install some i386 packages (non-critical, continuing...)") && \
        apt-get clean -y && \
        rm -rf /var/lib/apt/lists/* \
    ; fi

# Install ARM cross-compilation toolchains (optional, conflicts with gcc-multilib on some versions)
# On Ubuntu 25.04+, gcc-multilib conflicts with cross-compilation gcc
# These are primarily for embedded development and can be skipped if multilib is needed
RUN if [ "$(uname -m)" = "x86_64" ]; then \
        apt-get -y update && \
        (apt-get install --no-install-recommends -y \
            gcc-arm-linux-gnueabihf \
            gcc-aarch64-linux-gnu || \
            echo "Note: ARM cross-compilation toolchains not installed (may conflict with gcc-multilib)") && \
        apt-get clean -y && \
        rm -rf /var/lib/apt/lists/* \
    ; fi

# Install embedded Linux build tools (Yocto/Debian/Android)
RUN apt-get -y update && \
    apt-get install --no-install-recommends -y \
    binfmt-support \
    debootstrap \
    dosfstools \
    gdisk \
    gpart \
    kpartx \
    lvm2 \
    && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

# Install Node.js from NodeSource
RUN apt-get update && \
    curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - && \
    apt-get install -qy nodejs && \
    apt-get clean -y && \
    apt-get autoremove --purge -y && \
    rm -rf /var/lib/apt/lists/*

# Install Docker (conditionally install daemon)
# Note: Docker may not support the latest Ubuntu releases immediately.
# For unsupported releases, we fallback to the latest LTS (noble/24.04)
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | tee /etc/apt/keyrings/docker.asc > /dev/null && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    UBUNTU_CODENAME=$(lsb_release -cs) && \
    DOCKER_CODENAME=${UBUNTU_CODENAME} && \
    # Fallback to noble (24.04) for unsupported releases like plucky (25.04)
    if ! curl -fsSL https://download.docker.com/linux/ubuntu/dists/${UBUNTU_CODENAME}/stable/binary-amd64/Packages 2>/dev/null | grep -q "Package:"; then \
        echo "Docker repository not available for ${UBUNTU_CODENAME}, using noble (24.04) fallback"; \
        DOCKER_CODENAME="noble"; \
    fi && \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu ${DOCKER_CODENAME} stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    if [ "${INSTALL_DOCKER_DAEMON}" = "true" ]; then \
        apt-get install -qy \
            docker-ce \
            docker-ce-cli \
            containerd.io \
            docker-buildx-plugin \
            docker-compose-plugin; \
    else \
        apt-get install -qy \
            docker-ce-cli \
            docker-buildx-plugin \
            docker-compose-plugin; \
    fi && \
    apt-get clean -y && \
    apt-get autoremove --purge -y && \
    rm -rf /var/lib/apt/lists/* && \
    usermod -aG docker user

# Install Stripe CLI
RUN curl -s https://packages.stripe.dev/api/security/keypair/stripe-cli-gpg/public | gpg --dearmor | tee /usr/share/keyrings/stripe.gpg > /dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/stripe.gpg] https://packages.stripe.dev/stripe-cli-debian-local stable main" | tee -a /etc/apt/sources.list.d/stripe.list && \
    apt-get update && \
    apt-get install -qy stripe && \
    apt-get clean -y && \
    apt-get autoremove --purge -y && \
    rm -rf /var/lib/apt/lists/*

# Install Smallstep step-cli
RUN curl -fsSL https://packages.smallstep.com/keys/apt/repo-signing-key.gpg | tee /etc/apt/trusted.gpg.d/smallstep.asc > /dev/null && \
    echo 'deb [signed-by=/etc/apt/trusted.gpg.d/smallstep.asc] https://packages.smallstep.com/stable/debian debs main' | tee /etc/apt/sources.list.d/smallstep.list && \
    apt-get update && \
    apt-get install -qy step-cli && \
    apt-get clean -y && \
    apt-get autoremove --purge -y && \
    rm -rf /var/lib/apt/lists/*

# Install MinIO Client (mc)
RUN curl -sSL https://dl.min.io/client/mc/release/linux-amd64/mc -o /usr/local/bin/mc && \
    chmod +x /usr/local/bin/mc

# Install Google Cloud SDK (gcloud)
# Download GPG key to proper location, add repository with signed-by directive
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | \
    tee /etc/apt/sources.list.d/google-cloud-sdk.list && \
    apt-get update && \
    apt-get install -qy google-cloud-sdk && \
    apt-get clean -y && \
    apt-get autoremove --purge -y && \
    rm -rf /var/lib/apt/lists/*

# Install GitLab CLI (glab) - not available in Ubuntu 22.04 standard repos
RUN apt-get -y update && \
    (apt-get install --no-install-recommends -y glab || \
        echo "Note: glab not available (not in Ubuntu 22.04 repositories)") && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

# Create workspace directory
RUN mkdir -p /workspaces && \
    chown user:user /workspaces

USER user

# Install Python development tools
RUN pip3 install --upgrade pip && \
    pip3 install --no-cache-dir \
        black \
        pre-commit \
        yq \
        west && \
    pip3 cache purge && \
    sudo chown -R user:user ${VIRTUAL_ENV}

# Install Google repo tool
RUN sudo mkdir -p /usr/local/bin && \
    sudo curl -o /usr/local/bin/repo https://storage.googleapis.com/git-repo-downloads/repo && \
    sudo chmod a+rx /usr/local/bin/repo

# Copy user configuration files
COPY --chown=user:user conf/.bashrc /home/user/.bashrc
COPY --chown=user:user conf/pygdbinit /home/user/.pygdbinit
ADD entrypoint.sh /home/user/init

WORKDIR /workspaces

# Environment configuration
ENV DISPLAY=:0
ENV SHELL=/bin/bash
ENV EDITOR=vim

ENTRYPOINT ["/home/user/init"]
CMD ["/bin/bash"]

# ==============================================================================
# Stage: rust
# ==============================================================================
# Rust toolchain with cross-compilation targets
# ==============================================================================
FROM dev AS rust

USER root

# Install rustup
ENV RUSTUP_HOME=/opt/rust
ENV CARGO_HOME=/opt/rust
ENV PATH=${PATH}:/opt/rust/bin

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path

# Install cross-compilation targets in a single layer
RUN /opt/rust/bin/rustup target install \
    riscv32i-unknown-none-elf \
    riscv64imac-unknown-none-elf \
    thumbv6m-none-eabi \
    thumbv7em-none-eabi \
    thumbv7m-none-eabi \
    thumbv8m.main-none-eabi \
    x86_64-unknown-none

USER user

# Ensure Python virtual environment has proper ownership
RUN sudo chown -R user:user ${VIRTUAL_ENV}

# ==============================================================================
# Stage: zephyr-base
# ==============================================================================
# Common dependencies for Zephyr tooling
# ==============================================================================
FROM rust AS zephyr-base

USER root

# Install documentation toolchain and additional dependencies
RUN apt-get update && \
    apt-get install -qy --no-install-recommends \
    # Documentation generation
    bundler \
    dot2tex \
    doxygen-latex \
    latexmk \
    librsvg2-bin \
    ruby \
    ruby-dev \
    rubygems \
    texlive-fonts-recommended \
    texlive-fonts-extra \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-xetex \
    # AsciiDoc PDF generation
    curl \
    aspell \
    aspell-en \
    pandoc \
    # Additional build tools
    software-properties-common \
    # KiCad toolchain
    kicad \
    # Other tools
    imagemagick \
    && \
    apt-get clean -y && \
    apt-get autoremove --purge -y && \
    rm -rf /var/lib/apt/lists/*

USER user

# ==============================================================================
# Stage: zephyr-sdk (build-only)
# ==============================================================================
# Downloads and extracts Zephyr SDK
# ==============================================================================
FROM zephyr-base AS zephyr-sdk

ARG ZSDK_VERSION
ARG WGET_ARGS
ARG TARGETARCH

USER root

# Download and extract Zephyr SDK
# Map TARGETARCH (amd64/arm64) to HOSTTYPE (x86_64/aarch64)
RUN HOSTTYPE=$(case ${TARGETARCH} in \
        amd64) echo "x86_64";; \
        arm64) echo "aarch64";; \
        *) echo "x86_64";; \
    esac) && \
    mkdir -p /opt/toolchains && \
    cd /opt/toolchains && \
    wget ${WGET_ARGS} https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${ZSDK_VERSION}/zephyr-sdk-${ZSDK_VERSION}_linux-${HOSTTYPE}.tar.xz && \
    tar xf zephyr-sdk-${ZSDK_VERSION}_linux-${HOSTTYPE}.tar.xz && \
    rm zephyr-sdk-${ZSDK_VERSION}_linux-${HOSTTYPE}.tar.xz && \
    /opt/toolchains/zephyr-sdk-${ZSDK_VERSION}/setup.sh -t all -h -c

# ==============================================================================
# Stage: bsim (build-only)
# ==============================================================================
# Builds BabbleSim simulator
# ==============================================================================
FROM zephyr-base AS bsim

ARG BSIM_VERSION

USER root

# Build BSIM with west
RUN mkdir -p /opt/bsim_west && \
    cd /opt && \
    west init -m https://github.com/zephyrproject-rtos/babblesim-manifest.git --mr ${BSIM_VERSION} bsim_west && \
    cd bsim_west/bsim && \
    west update && \
    make everything -j $(nproc) && \
    echo ${BSIM_VERSION} > ./version && \
    chmod ag+w . -R

# ==============================================================================
# Stage: oss-cad (build-only)
# ==============================================================================
# Downloads OSS CAD Suite
# ==============================================================================
FROM zephyr-base AS oss-cad

ARG OSS_CAD_SUITE_VERSION
ARG WGET_ARGS
ARG TARGETARCH

USER root

# Download and extract OSS CAD Suite (x86_64 only)
RUN if [ "$(uname -m)" = "x86_64" ]; then \
        wget ${WGET_ARGS} https://github.com/YosysHQ/oss-cad-suite-build/releases/download/2024-02-11/oss-cad-suite-linux-x64-${OSS_CAD_SUITE_VERSION}.tgz && \
        tar xf oss-cad-suite-linux-x64-${OSS_CAD_SUITE_VERSION}.tgz -C /opt && \
        rm oss-cad-suite-linux-x64-${OSS_CAD_SUITE_VERSION}.tgz \
    ; fi

# ==============================================================================
# Stage: neovim (build-only)
# ==============================================================================
# Builds Neovim from source
# ==============================================================================
FROM zephyr-base AS neovim

ARG NEOVIM_VERSION

USER root

# Build Neovim and install to /opt/neovim
RUN git clone https://github.com/neovim/neovim.git && \
    cd neovim && \
    git checkout ${NEOVIM_VERSION} && \
    make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX=/opt/neovim -j $(nproc) && \
    make install && \
    cd .. && \
    rm -rf neovim

# ==============================================================================
# Stage: doxygen (build-only)
# ==============================================================================
# Downloads Doxygen binary (x86_64 only)
# ==============================================================================
FROM zephyr-base AS doxygen

ARG DOXYGEN_VERSION
ARG WGET_ARGS
ARG TARGETARCH

USER root

# Download Doxygen (x86_64 only)
RUN if [ "$(uname -m)" = "x86_64" ]; then \
        wget ${WGET_ARGS} https://downloads.sourceforge.net/project/doxygen/rel-${DOXYGEN_VERSION}/doxygen-${DOXYGEN_VERSION}.linux.bin.tar.gz && \
        tar xf doxygen-${DOXYGEN_VERSION}.linux.bin.tar.gz -C /opt && \
        rm doxygen-${DOXYGEN_VERSION}.linux.bin.tar.gz \
    ; fi

# ==============================================================================
# Stage: sparse (build-only)
# ==============================================================================
# Builds sparse for static analysis
# ==============================================================================
FROM zephyr-base AS sparse

ARG SPARSE_VERSION

USER root

# Build sparse
RUN mkdir -p /opt/sparse && \
    cd /opt/sparse && \
    git clone https://git.kernel.org/pub/scm/devel/sparse/sparse.git && \
    cd sparse && \
    git checkout ${SPARSE_VERSION} && \
    make -j $(nproc) && \
    PREFIX=/opt/sparse make install && \
    rm -rf /opt/sparse/sparse

# ==============================================================================
# Stage: protoc (build-only)
# ==============================================================================
# Downloads protobuf compiler
# ==============================================================================
FROM zephyr-base AS protoc

ARG PROTOC_VERSION
ARG WGET_ARGS
ARG TARGETARCH

USER root

# Download and extract protoc
RUN PROTOC_HOSTTYPE=$(case ${TARGETARCH} in \
        amd64) echo "x86_64";; \
        arm64) echo "aarch_64";; \
        *) echo "x86_64";; \
    esac) && \
    mkdir -p /opt/protoc && \
    cd /opt/protoc && \
    wget ${WGET_ARGS} https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-${PROTOC_HOSTTYPE}.zip && \
    unzip protoc-${PROTOC_VERSION}-linux-${PROTOC_HOSTTYPE}.zip && \
    rm -f protoc-${PROTOC_VERSION}-linux-${PROTOC_HOSTTYPE}.zip

# ==============================================================================
# Stage: zephyr
# ==============================================================================
# Complete Zephyr RTOS CI/build environment
# ==============================================================================
FROM zephyr-base AS zephyr

ARG LLVM_VERSION
ARG WGET_ARGS
ARG ZSDK_VERSION
ARG DOXYGEN_VERSION
ARG TARGETARCH

USER root

# Copy artifacts from build-only stages
COPY --from=zephyr-sdk /opt/toolchains /opt/toolchains
COPY --from=bsim /opt/bsim_west /opt/bsim_west
COPY --from=oss-cad /opt/oss-cad-suite* /opt/
COPY --from=doxygen /opt/doxygen* /opt/
COPY --from=sparse /opt/sparse /opt/sparse
COPY --from=protoc /opt/protoc /opt/protoc

# Create symlinks for tools
RUN ln -s /opt/bsim_west/bsim /opt/bsim 2>/dev/null || true && \
    if [ -d "/opt/doxygen-${DOXYGEN_VERSION}" ]; then \
        ln -s /opt/doxygen-${DOXYGEN_VERSION}/bin/doxygen /usr/local/bin/doxygen; \
    fi && \
    ln -s /opt/protoc/bin/protoc /usr/local/bin/protoc

# Install LLVM and Clang
RUN wget ${WGET_ARGS} https://apt.llvm.org/llvm.sh && \
    chmod +x llvm.sh && \
    ./llvm.sh ${LLVM_VERSION} all && \
    rm -f llvm.sh

# Install kibot
RUN pip3 install --no-compile kibot && \
    pip3 cache purge

# Install uefi-run utility
RUN cargo install uefi-run --root /usr

# Install Ruby gems for documentation and CMock
RUN gem install \
    asciidoctor-pdf \
    asciidoctor-epub3 \
    asciidoctor-html5s \
    bundler \
    rake \
    manifest \
    require_all \
    constructor \
    diy

# Install Python requirements
COPY requirements.txt /tmp/
COPY requirements-doc.txt /tmp/
COPY requirements-ci.txt /tmp/
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt && \
    rm /tmp/requirements*.txt && \
    pip3 cache purge && \
    chown -R user:user ${VIRTUAL_ENV}

# Install NRF command-line tools (amd64 only)
RUN if [ "$(uname -m)" = "x86_64" ]; then \
        apt-get update -qy && \
        apt-get install -qy --no-install-recommends \
            libusb-1.0-0-dev \
            libxcb-render-util0 \
            libxcb-shape0 \
            libxcb-randr0 \
            libxcb-xfixes0 \
            libxcb-sync1 \
            libxcb-icccm4 \
            libxcb-keysyms1 \
            libxcb-image0 \
            libxkbcommon0 \
            libxkbcommon-x11-0 \
            libx11-xcb1 \
            libcoap3-bin && \
        wget --no-verbose -P /tmp/ "https://nsscprodmedia.blob.core.windows.net/prod/software-and-other-downloads/desktop-software/nrf-command-line-tools/sw/versions-10-x-x/10-24-2/nrf-command-line-tools_10.24.2_amd64.deb" && \
        dpkg -i /tmp/nrf-command-line-tools_10.24.2_amd64.deb && \
        rm -f /tmp/nrf-command-line-tools_10.24.2_amd64.deb && \
        apt-get clean -y && \
        rm -rf /var/lib/apt/lists/* \
    ; fi

# Add user to hardware groups
RUN usermod -aG dialout user && \
    usermod -aG plugdev user

# Run Zephyr SDK setup as user
USER user

RUN sudo -E -- bash -c " \
    /opt/toolchains/zephyr-sdk-${ZSDK_VERSION}/setup.sh -c && \
    chown -R user:user /home/user/.cmake \
    "

# Ensure Python virtual environment has proper ownership
RUN sudo chown -R user:user ${VIRTUAL_ENV}

# Environment configuration
ENV HOSTNAME=zephyr
ENV ZEPHYR_TOOLCHAIN_VARIANT=zephyr
ENV PKG_CONFIG_PATH=/usr/lib/i386-linux-gnu/pkgconfig
ENV OVMF_FD_PATH=/usr/share/ovmf/OVMF.fd
ENV CMAKE_PREFIX_PATH=/opt/toolchains

USER root

# ==============================================================================
# Stage: workstation
# ==============================================================================
# Full developer workstation with UX tools and configurations
# ==============================================================================
FROM zephyr AS workstation

ARG NODE_VERSION
ARG NEOVIM_VERSION

USER root

# Copy built Neovim from build stage
COPY --from=neovim /opt/neovim /opt/neovim

# Create symlink for Neovim (overrides package neovim)
RUN ln -sf /opt/neovim/bin/nvim /usr/local/bin/nvim

USER user

# Install Ruby gems for developer experience
RUN sudo gem install \
    tmuxinator \
    neovim

# Install global npm packages and LSPs
RUN sudo npm install -g nmp && \
    sudo npm install -g \
        bash-language-server \
        pyright \
        tailwindcss-language-server \
        tree-sitter \
        typescript-language-server \
        vim-language-server \
        yaml-language-server \
        yarn && \
    npm cache clean --force

# Install additional Python packages
RUN pip3 install --no-cache-dir \
    pre-commit \
    mypy \
    robotframework-lsp \
    pynvim \
    ssss && \
    echo "Installing renode-run" && \
    pip3 install --upgrade git+https://github.com/antmicro/renode-run.git && \
    pip3 cache purge && \
    sudo chown -R user:user ${VIRTUAL_ENV}

# Copy user configuration files
COPY --chown=user:user conf/.tmux.conf /home/user/.tmux.conf
COPY --chown=user:user conf/.tmux.conf.local /home/user/.tmux.conf.local
COPY --chown=user:user conf/tmuxinator /home/user/.config/tmuxinator
COPY --chown=user:user conf/.bashrc /home/user/.bashrc
COPY --chown=user:user conf/pygdbinit /home/user/.pygdbinit
COPY --chown=user:user conf/nvim /home/user/.config/nvim/

# Install Neovim plugins
RUN curl -fLo ~/.local/share/nvim/site/autoload/plug.vim \
    --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
    nvim -e --headless '+PlugInstall --sync' +qa || true && \
    nvim -e --headless '+PlugInstall --sync' +qa || true && \
    nvim -e --headless '+TSInstall all' +qa || true

# Environment configuration
ENV DISPLAY=:0
ENV CMAKE_PREFIX_PATH=/opt/toolchains
ENV RUSTUP_HOME=/opt/rust
ENV CARGO_HOME=/opt/rust
ENV PATH=${PATH}:/opt/rust/bin
ENV HOSTNAME=workstation
ENV SHELL=/bin/bash
ENV EDITOR=vim

WORKDIR /workspace

ENTRYPOINT ["/home/user/init"]
CMD ["/bin/bash"]

# ==============================================================================
# End of Dockerfile
# ==============================================================================

