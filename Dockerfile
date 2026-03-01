FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    curl \
    wget \
    unzip \
    xz-utils \
    file \
    python3 \
    python3-pip \
    python3-venv \
    python-is-python3 \
    build-essential \
    cmake \
    ninja-build \
    pkg-config \
    bison \
    flex \
    bc \
    libssl-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libelf-dev \
    cpio \
    rsync \
    u-boot-tools \
    device-tree-compiler \
    qemu-utils \
    dosfstools \
    mtools \
    parted \
    jq \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /work

COPY scripts/build_cs300fvp_ubuntu.sh /usr/local/bin/build_cs300fvp_ubuntu.sh
RUN chmod +x /usr/local/bin/build_cs300fvp_ubuntu.sh

ENTRYPOINT ["/usr/local/bin/build_cs300fvp_ubuntu.sh"]
