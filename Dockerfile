ARG UBUNTU_VERSION
FROM ubuntu:${UBUNTU_VERSION} as base

ARG GCC_VERSION
RUN set -x && echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update && \
    apt-get install -y -q apt-utils dialog && \
    apt-get install -y -q sudo aptitude flex bison libncurses5-dev make git exuberant-ctags bc libssl-dev libelf-dev && \
    apt-get install -y -q python3 cmake && \
    apt-get install -y -q gcc-${GCC_VERSION} g++-${GCC_VERSION} gcc g++

WORKDIR /project-src

CMD ["bash"]
