# 
# quiche build image
#

# build quiche binary
FROM debian:latest AS builder

# dependencies
RUN apt-get update && apt-get install -y cmake golang git curl

# rust need to be installed via rustup since it requires 1.39
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | \
    sh -s -- --default-toolchain stable -y
ENV PATH=/root/.cargo/bin:$PATH

# build quiche
RUN git clone --recursive https://github.com/cloudflare/quiche.git
WORKDIR /quiche
RUN cargo build --examples
RUN cargo test

# setup interop image
FROM debian:latest

WORKDIR /quiche

RUN apt-get update && apt-get install -y ca-certificates

# copy binaries and sample certificate for server
COPY --from=builder /quiche/examples/cert.crt examples/ 
COPY --from=builder /quiche/examples/cert.key examples/ 
COPY --from=builder /quiche/target/release/examples/client .
COPY --from=builder /quiche/target/release/examples/server .
COPY --from=builder /quiche/target/release/examples/http3-client .
COPY --from=builder /quiche/target/release/examples/http3-server .

COPY test.html examples/
