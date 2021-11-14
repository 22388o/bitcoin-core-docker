ARG ubuntuVersion=20.04

FROM ubuntu:${ubuntuVersion}

LABEL maintainer="Florent Dufour <florent+github@dufour.xyz>"
LABEL description="Bitcoin full node from docker, built from source."
LABEL version="0.21.1"

ENV DEBIAN_FRONTEND noninteractive
ENV TZ Europe/Paris

# Available bitcoin versions: https://github.com/bitcoin/bitcoin/releases
ARG bitcoinVersion=v0.21.1
ARG berkeleydbVersion=db-4.8.30.NC

# Update \ && install tools \ install build dependencies \ install librairies \ && clean
RUN apt-get update -y \
  && apt-get install --no-install-recommends -y ca-certificates locales git wget vim \
  build-essential libtool autotools-dev automake pkg-config bsdmainutils python3 \
  libssl-dev libevent-dev libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-test-dev libboost-thread-dev \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /root/.cache  \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Checkout bitcoin source:
WORKDIR /tmp
RUN git clone --verbose -b ${bitcoinVersion} --depth=1 https://github.com/bitcoin/bitcoin.git bitcoin

# Install Berkeley Database:
RUN wget http://download.oracle.com/berkeley-db/${berkeleydbVersion}.tar.gz && tar -xvf db-4.8.30.NC.tar.gz
WORKDIR /tmp/db-4.8.30.NC/build_unix
RUN mkdir -p build
RUN BDB_PREFIX=$(pwd)/build
RUN ../dist/configure --disable-shared --enable-cxx --with-pic --prefix=$BDB_PREFIX
RUN make install

# Install bitcoin:
WORKDIR /tmp/bitcoin
RUN ./autogen.sh && ./configure CPPFLAGS="-I${BDB_PREFIX}/include/ -O2" LDFLAGS="-L${BDB_PREFIX}/lib/" --without-gui
RUN make && make install

# System config:
RUN echo "alias 'log=tail -f /root/.bitcoin/debug.log'" >> /root/.bashrc
RUN echo "alias 'logtest=tail -f /root/.bitcoin/testnet3/debug.log'" >> /root/.bashrc

WORKDIR /
ENTRYPOINT bitcoind
