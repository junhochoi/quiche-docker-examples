# 
# curl + quiche build image
#
FROM rust:1.39 AS builder

# Dependencies
RUN apt-get update && apt-get install -y cmake golang curl automake autoconf libtool pkg-config

# Build curl + quiche
# https://github.com/curl/curl/blob/master/docs/HTTP3.md
WORKDIR /build
RUN git clone --recursive https://github.com/cloudflare/quiche.git

# Build boringssl
RUN cd quiche/deps/boringssl && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_POSITION_INDEPENDENT_CODE=on .. && \
    make -j`nproc` && \
    cd .. && \
    mkdir -p .openssl/lib && \
    cp build/crypto/libcrypto.a build/ssl/libssl.a .openssl/lib && \
    ln -s $PWD/include .openssl

# Build quiche
RUN cd quiche && \
    QUICHE_BSSL_PATH=$PWD/deps/boringssl cargo build --release --features pkg-config-meta

# Build curl
RUN git clone https://github.com/curl/curl.git && \
    cd curl && \
    ./buildconf && \
    ./configure LDFLAGS="-Wl,-rpath,$PWD/../quiche/target/release" \
        --prefix=/usr/local \
        --with-ssl=$PWD/../quiche/deps/boringssl/.openssl \
        --with-quiche=$PWD/../quiche/target/release && \
    make -j`nproc` && \
    make install

# Setup binary image
FROM debian:latest

RUN apt-get update && apt-get install -y ca-certificates

COPY --from=builder /usr/local /usr/local
COPY --from=builder /build/quiche/target/release/libquiche.a /usr/local/lib/
COPY --from=builder /build/quiche/target/release/libquiche.so /usr/local/lib/

RUN rm /etc/ld.so.cache && ldconfig
