# 
# curl + quiche build image
#

# build quiche binary
FROM debian:latest AS builder

# dependencies
RUN apt-get update && apt-get install -y cmake golang git curl automake autoconf libtool pkg-config

# rust need to be installed via rustup since it requires 1.39
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | \
    sh -s -- --default-toolchain stable -y
ENV PATH=/root/.cargo/bin:$PATH

# build curl + quiche
# https://github.com/curl/curl/blob/master/docs/HTTP3.md
WORKDIR /build
RUN git clone --recursive https://github.com/cloudflare/quiche.git

# boringssl
RUN cd quiche/deps/boringssl && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_POSITION_INDEPENDENT_CODE=on .. && \
    make -j`nproc` && \
    cd .. && \
    mkdir -p .openssl/lib && \
    cp build/crypto/libcrypto.a build/ssl/libssl.a .openssl/lib && \
    ln -s $PWD/include .openssl

# quiche
RUN cd quiche && \
    QUICHE_BSSL_PATH=$PWD/deps/boringssl cargo build --release --features pkg-config-meta

# curl
RUN git clone https://github.com/curl/curl.git && \
    cd curl && \
    ./buildconf && \
    ./configure LDFLAGS="-Wl,-rpath,$PWD/../quiche/target/release" \
        --prefix=/usr/local \
        --with-ssl=$PWD/../quiche/deps/boringssl/.openssl \
        --with-quiche=$PWD/../quiche/target/release && \
    make -j`nproc` && \
    make install

# setup binary image
FROM debian:latest

RUN apt-get update && apt-get install -y ca-certificates

COPY --from=builder /usr/local /usr/local
COPY --from=builder /build/quiche/target/release/libquiche.a /usr/local/lib/
COPY --from=builder /build/quiche/target/release/libquiche.so /usr/local/lib/

RUN rm /etc/ld.so.cache && ldconfig
