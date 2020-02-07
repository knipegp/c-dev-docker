FROM knipegp/docker-base

RUN apt update
RUN apt upgrade -y
RUN apt install -y clangd-9
RUN apt install -y clang-tools-9
RUN apt install -y clang-tidy
RUN apt install -y lldb
RUN apt install -y gcc
RUN apt install -y g++
RUN apt install -y glibc-doc
RUN apt install -y python3
RUN apt install -y python3-pip
Run apt install -y wget

RUN wget https://github.com/oclint/oclint/releases/download/v0.13.1/oclint-0.13.1-x86_64-linux-4.4.0-112-generic.tar.gz && \
    tar -zxf oclint-0.13.1-x86_64-linux-4.4.0-112-generic.tar.gz && \
    cp oclint-0.13.1/bin/oclint* /usr/local/bin/ && \
    cp -rp oclint-0.13.1/lib/* /usr/local/lib/

USER developer
WORKDIR /home/developer

RUN pip3 install --user compiledb

ENV PATH="~/.local/bin:${PATH}"

# Install YouCompleteMe
# Add flags to end of command for particular language support
RUN python3 ./.config/nvim/plugged/YouCompleteMe/install.py --clangd-completer

COPY CPlugIns.vim ./
RUN cat CPlugIns.vim >> ./dotfiles/vimscripts/PlugIns.vim
