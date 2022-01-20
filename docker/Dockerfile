FROM ubuntu:focal
RUN echo ' \n\
APT::Periodic::Update-Package-Lists "0";\n\
APT::Periodic::Download-Upgradeable-Packages "0";\n\
APT::Periodic::AutocleanInterval "0";\n\
APT::Periodic::Unattended-Upgrade "1";\n'\
> /etc/apt/apt.conf.d/20auto-upgrades
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Seoul
RUN set -x \
    && apt-get update && apt-get install -y build-essential snapd aptitude git wget golang \
    python3 python3-pip python3-setuptools python3-wheel ninja-build \
    libgstreamer1.0-dev libgirepository1.0-dev libunwind-dev apt-utils \
    gdb \
    && aptitude install -y libmicrohttpd-dev libjansson-dev \
	libssl-dev libsofia-sip-ua-dev libglib2.0-dev \
	libopus-dev libogg-dev libcurl4-openssl-dev liblua5.3-dev \
	libconfig-dev pkg-config gengetopt libtool automake \
	libnanomsg-dev
RUN set -x \
    && wget https://github.com/Kitware/CMake/releases/download/v3.22.1/cmake-3.22.1.tar.gz \
    && tar -xvzf cmake-3.22.1.tar.gz \
    && cd cmake-3.22.1 \
    && ./bootstrap --prefix=/usr/local \
    && make -j8 && make install
RUN set -x \
    && python3 -m pip install meson \
    && python3 -m pip install ninja
RUN set -x \
    && git clone https://github.com/freedesktop/libnice.git \
    && cd libnice \
    && meson --prefix=/usr build && ninja -C build && ninja -C build install
RUN set -x \
    && aptitude remove libsrtp2-dev
RUN set -x \
    && wget https://github.com/cisco/libsrtp/archive/v2.2.0.tar.gz \
    && tar xfv v2.2.0.tar.gz \
    && cd libsrtp-2.2.0 \
    && ./configure --prefix=/usr --enable-openssl \
    && make shared_library && make install
RUN set -x \
    && git clone https://boringssl.googlesource.com/boringssl \
    && cd boringssl \
    && sed -i s/" -Werror"//g CMakeLists.txt \
    && mkdir -p build \
    && cd build \
    && cmake -DCMAKE_CXX_FLAGS="-lrt" .. \
    && make -j8 \
    && cd .. \
    && mkdir -p /opt/boringssl \
    && cp -R include /opt/boringssl/ \
    && mkdir -p /opt/boringssl/lib \
    && cp build/ssl/libssl.a /opt/boringssl/lib/ \
    && cp build/crypto/libcrypto.a /opt/boringssl/lib/
RUN  set -x \
    && git clone https://github.com/sctplab/usrsctp \
    && cd usrsctp \
    && ./bootstrap \
    && ./configure --prefix=/usr --disable-programs --disable-inet --disable-inet6 \ 
    && make -j8 && make install
RUN  set -x \
    && git clone https://libwebsockets.org/repo/libwebsockets \
    && cd libwebsockets \
    && git checkout v3.2-stable \
    && mkdir build \
    && cd build \
    && cmake -DLWS_MAX_SMP=1 -DLWS_WITHOUT_EXTENSIONS=0 -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_C_FLAGS="-fpic" .. \
    && make -j8 && make install
RUN set -x \
    && git clone https://github.com/eclipse/paho.mqtt.c.git \
    && cd paho.mqtt.c \
    && make -j8 && make install
RUN set -x \
    && git clone https://github.com/alanxz/rabbitmq-c \
    && cd rabbitmq-c \
    && git submodule init \
    && git submodule update \
    && mkdir build && cd build \
    && cmake -DCMAKE_INSTALL_PREFIX=/usr .. \
    && make -j8 && make install

ARG CACHEBUST=1

ARG SSH_PRIVATE_KEY
RUN set -x \
    && mkdir /root/.ssh/ \
    && echo "${SSH_PRIVATE_KEY}" >> /root/.ssh/id_rsa \
    && chmod 600 /root/.ssh/id_rsa \
    && touch /root/.ssh/known_hosts \
    && ssh-keyscan github.com >> /root/.ssh/known_hosts
RUN export JANUS_WITH_POSTPROCESSING
RUN  set -x \
    && git clone git@github.com:DaeyangCho/janus-gateway.git \
    && cd janus-gateway \
    && git checkout klleon \
    && sh autogen.sh \
    && ./configure --prefix=/opt/janus \
    && make -j8 \
    && make install \
    && make configs
RUN  set -x \
    && rm -rf /libwebsockets \
    && rm -rf /janus-gateway \
    && rm -rf /boringssl \
    && rm /root/.ssh/id_rsa
RUN adduser --disabled-password --gecos '' janus
USER janus
RUN /opt/janus/bin/janus --v
CMD ["/opt/janus/bin/janus"]
