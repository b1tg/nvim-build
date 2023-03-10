FROM centos:centos7.4.1708
RUN yum install -y \
    vim bash-com* openssh-clients openssh-server iproute cronie tmux wget;\
    yum group install -y "Development Tools";yum clean all;\
    localedef -c -f UTF-8 -i zh_CN zh_CN.UTF-8 && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
ENV LANG=en_US.UTF-8
RUN yum install -y epel-release
RUN yum install -y ninja-build libtool cmake3 make pkgconfig unzip gettext curl
RUN yum install -y libmpc-devel mpfr-devel gmp-devel
RUN curl ftp://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-4.9.2/gcc-4.9.2.tar.bz2 -O
RUN tar xvfj gcc-4.9.2.tar.bz2 && cd gcc-4.9.2
RUN cd gcc-4.9.2 && ./configure --disable-multilib --enable-languages=c,c++ && \
    make -j 4 && make install && rm -rf gcc-4.9.2 gcc-4.9.2.tar.bz2
RUN gcc --version
RUN rm -f /usr/bin/cc
RUN ln -s /usr/local/bin/gcc /usr/bin/cc
RUN git clone https://github.com/neovim/neovim --depth=1
RUN cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
RUN cd neovim && make install && rm -rf neovim
# ENV LANG=zh_CN.UTF-8
# NyaMisty/simple_dev_docker
RUN yum install -y zlib-devel openssl-devel bzip2-devel libsqlite3x-devel
RUN yum install -y libffi-devel # fix missing _ctypes when install mitmproxy
RUN git clone https://github.com/pyenv/pyenv.git /opt/pyenv && cd /opt/pyenv && src/configure && make -C src
RUN export PYENV_ROOT="${PYENV_ROOT:-/opt/pyenv}" && export PATH="$PYENV_ROOT/bin:$PATH" && \
    eval "$(pyenv init --path)" && eval "$(pyenv init -)" && \
    pyenv install 2.7.13 && pyenv install 3.9.5 && pyenv global 2.7.13 3.9.5 system && \
    pip install requests ipython && \
    pip3 install requests ipython
RUN rm -rf gcc-4.9.2 gcc-4.9.2.tar.bz2 neovim

RUN wget https://go.dev/dl/go1.20.2.linux-amd64.tar.gz && \
    rm -rf /usr/local/go && tar -C /usr/local -xzf go1.20.2.linux-amd64.tar.gz && \
    export PATH=$PATH:/usr/local/go/bin && \
    rm -f go1.20.2.linux-amd64.tar.gz

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN source "$HOME/.cargo/env"
RUN echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bashrc

CMD ["bash"]

