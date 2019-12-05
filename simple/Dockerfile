#
# quiche build image
#
FROM rust:1.39 AS builder

# Dependencies
RUN apt-get update && apt-get install -y cmake golang

# Build quiche
RUN git clone --recursive https://github.com/cloudflare/quiche.git
WORKDIR /quiche
RUN cargo build --examples
RUN cargo test

# Setup binary image
FROM debian:latest

WORKDIR /quiche

RUN apt-get update && apt-get install -y ca-certificates

# Copy binaries and sample certificate for server
COPY --from=builder /quiche/examples/cert.crt /quiche/examples/cert.key examples/
COPY --from=builder /quiche/target/debug/examples/client \
     /quiche/target/debug/examples/server \
     /quiche/target/debug/examples/http3-client \
     /quiche/target/debug/examples/http3-server \
     ./

# HTML example
COPY test.html examples/
