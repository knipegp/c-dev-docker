FROM knipegp/docker-base:0.0.1

USER root
WORKDIR /root

RUN apt-get update && apt-get install -y --no-install-recommends \
    clangd-9=1:9-2~ubuntu18.04.2 \
    clang-tools-9=1:9-2~ubuntu18.04.2 \
    clang-tidy-9=1:9-2~ubuntu18.04.2 \
    lldb-9=1:9-2~ubuntu18.04.2 \
    gcc=4:7.4.0-1ubuntu2.3 \
    libc6-dev=2.27-3ubuntu1 \
    g++=4:7.4.0-1ubuntu2.3 \
    gdb=8.1-0ubuntu3.2 \
    libcc1-0=8.3.0-26ubuntu1~18.04 \
    gdbserver=8.1-0ubuntu3.2 \
    gdb-doc=8.1-0ubuntu3.2 \
    glibc-doc=2.27-3ubuntu1 \
    manpages-dev=4.15-1 \
    python3=3.6.7-1~18.04 \
    # TODO: Test if pip is necessary
    python3-pip=9.0.1-2.3~ubuntu1.18.04.1 \
    python3-dev=3.6.7-1~18.04 \
    python3-setuptools=39.0.1-2 \
    python3-wheel=0.30.0-0.2 \
    python3-keyring=10.6.0-1 \
    python3-keyrings.alt=3.0-1 \
    python3-xdg=0.25-4ubuntu1 \
    wget=1.19.4-1ubuntu2.2 \
    valgrind=1:3.13.0-2ubuntu2.2 \
    libarchive-zip-perl=1.60-1ubuntu0.1 \
    && rm -rf /var/lib/apt/lists/*

# RR config
RUN apt-get update && apt-get install -y ccache cmake make g++-multilib gdb \
  pkg-config coreutils python3-pexpect manpages-dev git \
  ninja-build capnproto libcapnp-dev
RUN git clone https://github.com/mozilla/rr.git \
    && mkdir obj && cd obj \
    && cmake ../rr \
    && make -j8 && make install
##

RUN ln -s /usr/bin/clang-tidy-9 /usr/bin/clang-tidy \
    && ln -s /usr/bin/clang-check-9 /usr/bin/clang-check

RUN wget https://github.com/oclint/oclint/releases/download/v0.13.1/oclint-0.13.1-x86_64-linux-4.4.0-112-generic.tar.gz && \
    tar -zxf oclint-0.13.1-x86_64-linux-4.4.0-112-generic.tar.gz && \
    cp oclint-0.13.1/bin/oclint* /usr/local/bin/ && \
    cp -rp oclint-0.13.1/lib/* /usr/local/lib/

USER developer
WORKDIR /home/developer

ENV PATH="~/.local/bin:${PATH}"
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN pip3 install --user compiledb==0.10.1
RUN pip3 install --user gdbgui==0.13.2.0

# Install YouCompleteMe
# Add flags to end of command for particular language support
RUN python3 ./.config/nvim/plugged/YouCompleteMe/install.py --clangd-completer

COPY CPlugIns.vim ./
RUN cat CPlugIns.vim >> ./dotfiles/vimscripts/PlugIns.vim
