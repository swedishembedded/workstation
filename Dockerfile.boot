FROM ubuntu:24.10

ARG UID=1000
ARG GID=1000

# Set default shell
SHELL ["/bin/bash", "-c"]

# Non-interactive mode for apt
ENV DEBIAN_FRONTEND=noninteractive

# Install core system utilities and security essentials
RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get install --no-install-recommends -y \
        ca-certificates \
        curl \
        gnupg \
        wget \
        locales \
        sudo \
        lsb-release \
        && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

# Set up UTF-8 locale
RUN locale-gen en_US.UTF-8 sv_SE.UTF-8
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LC_CTYPE=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV KEYBOARD=sv
RUN dpkg-reconfigure locales

# Install essential build tools
RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get install --no-install-recommends -y \
        build-essential \
        cmake \
        gcc \
        g++ \
        make \
        ninja-build \
        && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

# Install Python with virtual environment support
RUN apt-get -y update && \
    apt-get -y install --no-install-recommends \
        python3-dev \
        python3-pip \
        python3-setuptools \
        python3-venv \
        python-is-python3 \
        && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

# Create a non-root user with minimal privileges
RUN userdel ubuntu || true && \
    groupadd -g $GID -o user && \
    useradd -u $UID -m -g user -G sudo user && \
    echo 'user ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/user && \
    chmod 0440 /etc/sudoers.d/user

USER user

ENV VIRTUAL_ENV=/home/user/.venv

# Create a Python virtual environment
RUN python3 -m venv $VIRTUAL_ENV && \
    chown -R user:user $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Upgrade pip and install essential Python utilities
RUN python3 -m pip install -U --no-cache-dir pip && \
    pip3 install -U --no-cache-dir wheel setuptools && \
    pip3 check && \
    pip3 cache purge && \
    chown -R user:user $VIRTUAL_ENV

WORKDIR /home/user

CMD ["/bin/bash"]
